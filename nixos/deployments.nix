# File containing deployments
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  pbPackage = pkgs.pocketbase.overrideAttrs (_f: rec {
    version = "v0.34.2";
    src = pkgs.fetchFromGitHub {
      owner = "pocketbase";
      repo = "pocketbase";
      rev = "${version}";
      hash = "sha256-Ytvti0RBpbpFIaoqR6+YBYkFydcDKGbDGUapmy6TdHU=";
    };
    vendorHash = "sha256-Oo0zfS7WLrF6hpphuWMV6Of7k6ezcWp3MtfQgCiSuo8=";
  });
  pbDataDir = "/var/lib/pocketbase";
  pbBackupDir = "${pbDataDir}/backups";
in {
  security.sudo.extraRules = [
    {
      users = ["${config.users.users.beni.name}"];
      commands = [
        {
          command = "/run/current-system/sw/bin/machinectl shell pocketbase@justcount /run/current-system/sw/bin/bash";
        }
      ];
      runAs = "root:root";
    }
  ];

  containers = {
    justcount = {
      autoStart = true;
      config = {
        config,
        pkgs,
        ...
      }: let
        pbListenAddr = "127.0.0.1:8092";
      in {
        system.stateVersion = "23.11";
        environment.systemPackages = with pkgs; [pocketbase];
        users.users.pocketbase = {
          isSystemUser = true;
          home = pbDataDir;
          shell = "/run/current-system/sw/bin/nologin";
          group = "pocketbase";
          createHome = true;
        };
        users.groups.pocketbase = {};
        security.sudo = {
          enable = true;
          extraRules = [
            {
              users = ["${config.users.users.pocketbase.name}"];
              commands = map (cmd: {
                command = "/run/current-system/sw/bin/systemctl ${cmd} ${config.systemd.services.justcount-pb.name}";
                options = ["NOPASSWD"];
              }) ["restart" "stop" "start"];
              runAs = "root:root";
            }
          ];
        };

        systemd = {
          timers.justcount-pb-backup = {
            timerConfig = {
              RandomizedDelaySec = "15min";
              OnCalendar = "02:00:00";
              Unit = config.systemd.services.justcount-pb-backup.name;
            };
            unitConfig = {
              description = "Timer for pocketbase backup.";
              Requires = config.systemd.services.justcount-pb-backup.name;
            };
            wantedBy = ["timers.target"];
          };
          services = {
            justcount-pb = {
              unitConfig.description = "Pocketbase for justcount";
              serviceConfig = {
                ExecStart = "${pbPackage}/bin/pocketbase serve --dir ${pbDataDir}/pb_data --publicDir ${pbDataDir}/pb_public --hooksDir ${pbDataDir}/pb_hooks --http ${pbListenAddr}";
                Restart = "always";
                RestartSec = "5s";
                Type = "simple";
                User = "pocketbase";
                Group = "pocketbase";
              };
              wantedBy = ["multi-user.target"];
            };
            justcount-pb-backup = {
              wantedBy = ["multi-user.target"];
              path = with pkgs; [
                coreutils
                gnutar
                gzip
              ];
              unitConfig.description = "Backup for justcount pocketbase";
              serviceConfig = {
                Type = "oneshot";
                Restart = "no";
                ExecStartPost = [
                  "-/run/current-system/sw/bin/systemctl start ${config.systemd.services.justcount-pb.name}"
                ];
                ExecStartPre = [
                  "/run/current-system/sw/bin/systemctl stop ${config.systemd.services.justcount-pb.name}"
                ];
                ExecStart = pkgs.writeShellScript "pb-backup-start" ''
                  echo "Starting backup..."
                  mkdir -p "${pbBackupDir}"
                  tar -czf ${pbBackupDir}/$(date +"backup-%Y-%m-%dT%H%M.tar.gz") ${pbDataDir}/pb*
                  ls -t ${pbBackupDir}/backup-*.tar.gz | tail -n +8 | xargs -r rm
                  echo "Backup finished."
                '';
              };
            };
          };
        };
      };
    };
  };

  services.spetsctf = {
    enable = true;
    httpOrigin = "https://ctf.spetsen.net";

    postgresConnectionStringFile = config.sops.secrets."spetsctf/database_url".path;

    github = {
      clientIdFile = config.sops.secrets."spetsctf/github_client_id".path;
      clientSecretFile = config.sops.secrets."spetsctf/github_client_secret".path;
    };

    # We leave the socketPath as the default.
    # socketPath = ...;
  };

  systemd.services.caddy = {
    after = [config.systemd.services.spetsctf.name];
    serviceConfig = {SupplementaryGroups = ["spetsctf"];};
  };

  sops.secrets."aulabokning/environment_file".sopsFile = ../secrets/secrets.yaml;

  microvm.vms = {
    spetsctf-services = {
      config =
        {
          microvm = {
            hypervisor = "qemu";
            mem = 8192;
            vcpu = 4;

            interfaces = [
              {
                type = "tap";
                id = "vm-spetsctf";
                mac = "02:00:00:00:00:01";
              }
            ];
          };
        }
        // inputs.spetsctf-services.nixosConfigurations."spetsctf-services";
    };
  };

  systemd.services.aulabokning = let
    aulabokningPath = inputs.aulabokning.packages."${pkgs.stdenv.hostPlatform.system}".default;
  in {
    environment = {
      PORT = "4041";
      NODE_ENV = "production";
      REDIS_SOCKET_PATH = "/tmp/redis.sock";
    };
    serviceConfig = {
      DynamicUser = "yes";
      EnvironmentFile = config.sops.secrets."aulabokning/environment_file".path;
      ExecStart = "${lib.getExe pkgs.nodejs_22} ${aulabokningPath}/server.js";
      Group = "redis-aulabokning";
      NoNewPrivileges = "yes";
      PrivateDevices = "yes";
      PrivateTmp = "yes";
      ProcSubset = "pid";
      ProtectClock = "yes";
      ProtectHome = "yes";
      ProtectKernelLogs = "yes";
      ProtectKernelModules = "yes";
      ProtectSystem = "strict";
      Restart = "on-failure";
      RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX";
      RestrictRealtime = "yes";
      StateDirectory = "aulabokning";
      SystemCallFilter = "@system-service";
      Type = "simple";
      UMask = "0077";
    };
    wantedBy = ["multi-user.target"];
  };

  services.redis.servers.aulabokning = {
    enable = true;
    port = 0;
    unixSocket = "/tmp/redis.sock";
    unixSocketPerm = 660;
  };

  systemd.services.redis-aulabokning = {
    # PrivateTmp is already set.
    unitConfig = {
      JoinsNamespaceOf = "aulabokning.service";
    };
  };
}
