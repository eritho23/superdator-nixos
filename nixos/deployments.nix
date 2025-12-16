# File containing deployments
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
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

  containers.justcount = {
    autoStart = true;
    config = {
      config,
      pkgs,
      ...
    }: let
      pbDataDir = "/var/lib/pocketbase";
      pbListenAddr = "127.0.0.1:8092";
      pbPackage = pkgs.pocketbase.overrideAttrs (f: rec {
        version = "v0.34.2";
        src = pkgs.fetchFromGitHub {
          owner = "pocketbase";
          repo = "pocketbase";
          rev = "${version}";
          hash = "sha256-Ytvti0RBpbpFIaoqR6+YBYkFydcDKGbDGUapmy6TdHU=";
        };
        vendorHash = "sha256-Oo0zfS7WLrF6hpphuWMV6Of7k6ezcWp3MtfQgCiSuo8=";
      });
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
            commands = [
              {
                command = "/run/current-system/sw/bin/systemctl restart ${config.systemd.services.justcount-pb.name}";
                options = ["NOPASSWD"];
              }
              {
                command = "/run/current-system/sw/bin/systemctl stop ${config.systemd.services.justcount-pb.name}";
                options = ["NOPASSWD"];
              }
              {
                command = "/run/current-system/sw/bin/systemctl start ${config.systemd.services.justcount-pb.name}";
                options = ["NOPASSWD"];
              }
            ];
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
                mkdir -p "${pbDataDir}/backups"
                tar -czf ${pbDataDir}/backups/$(date +"backup-%Y-%m-%dT%H%M.tar.gz") ${pbDataDir}/pb*
                ls -t "$BACKUP_DIR"/myapp-*.tar.gz | tail -n +8 | xargs -r rm
                echo "Backup finished."
              '';
            };
          };
        };
      };
    };
  };

  users.groups.spetsctf = {};
  users.users.spetsctf = let
    spetsCtfDataDir = "/var/lib/spetsctf";
  in {
    isSystemUser = true;
    home = spetsCtfDataDir;
    createHome = true;
    shell = "/run/current-system/sw/bin/nologin";
    group = "spetsctf";
  };

  systemd.services.spetsctf = let
    spetsCtfWebBundle = inputs.spetsctf.packages."${pkgs.system}".spetsctf;
  in {
    after = ["postgresql.service"];
    requires = ["postgresql.service"];
    environment = {
      ADDRESS_HEADER = "X-Forwarded-For";
      HOST_HEADER = "X-Forwarded-Host";
      NODE_ENV = "production";
      ORIGIN = "https://ctf.spetsen.net";
      PORT = "3333";
      PROTOCOL_HEADER = "X-Forwarded-Proto";
    };
    serviceConfig = {
      EnvironmentFile = "${config.sops.secrets."spetsctf/environment_file".path}";
      ExecStart = "${pkgs.nodejs_22}/bin/node ${spetsCtfWebBundle}";
      Group = "spetsctf";
      NoNewPrivileges = "yes";
      ProcSubset = "pid";
      ProtectSystem = "yes";
      ReadWritePaths = "/var/lib/spetsctf";
      Restart = "no";
      Type = "simple";
      User = "spetsctf";
      WorkingDirectory = "/var/lib/spetsctf";
    };
    wantedBy = ["multi-user.target"];
  };

  sops.secrets."aulabokning/environment_file".sopsFile = ../secrets/secrets.yaml;

  microvm.vms = {
    spetsctf-services = {
      config = {
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

        users.users."root".openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH5Ysdzr8kUAzQf+v7g+RKqaG+7J0Y/Q7pwKUstIlesR erre@superdator"];
        services.openssh.enable = true;
        services.openssh.openFirewall = true;

        users.groups."chall-user" = {};
        users.users."chall-user" = {
          isSystemUser = true;
          shell = "/run/current-system/sw/bin/nologin";
          group = "chall-user";
          home = "/var/lib/chall-user";
          createHome = true;
          homeMode = "700";
          subUidRanges = [
            {
              count = 65535;
              startUid = 100000;
            }
          ];
          subGidRanges = [
            {
              count = 65535;
              startGid = 100000;
            }
          ];
        };

        users.mutableUsers = false;
        system.switch.enable = false;
        system.etc.overlay.mutable = false;

        virtualisation.oci-containers = {
          backend = "podman";
          containers = {
            "bazaar_bank_at_sea" = {
              image = "bazaar_bank_at_sea:1";
              imageStream = inputs.spetsctf-services.packages.x86_64-linux.bazaar_bank_at_sea;
              ports = [
                "45907:5000"
              ];
              extraOptions = [
                "--read-only=true"
                "--tmpfs=/tmp:rw"
              ];
              hostname = "chall";
              podman.user = "chall-user";
            };
            "bazaar_silent_deadly" = {
              image = "bazaar_silent_deadly:5";
              imageStream = inputs.spetsctf-services.packages.x86_64-linux.bazaar_silent_deadly;
              ports = [
                "42764:5000"
              ];
              extraOptions = [
                "--read-only=true"
                "--tmpfs=/tmp:rw"
              ];
              hostname = "chall";
              podman.user = "chall-user";
            };
            "plz_give" = {
              image = "plz_give:1";
              imageStream = inputs.spetsctf-services.packages.x86_64-linux.plz_give;
              ports = [
                "45508:1337"
              ];
              extraOptions = [
                "--read-only=true"
                "--tmpfs=/tmp:rw"
              ];
              hostname = "chall";
              podman.user = "chall-user";
            };
            "fd_tillganglig_eller" = {
              image = "fd_tillganglig_eller:1";
              imageFile = inputs.spetsctf-services.packages.x86_64-linux.fd_tillganglig_eller;
              ports = [
                "46171:4000"
              ];
              extraOptions = [
                "--read-only=true"
              ];
              hostname = "chall";
              podman.user = "chall-user";
            };
          };
        };

        networking.firewall.enable = true;
        networking.firewall.allowedTCPPortRanges = [
          # Services are hosted between these ports.
          {
            from = 40000;
            to = 48000; # 48000-50000 are for services for SpetsCTF
          }
        ];

        systemd.network.enable = true;
        systemd.network.networks."10-lan" = {
          matchConfig.Type = "ether";
          networkConfig = {
            Address = ["10.22.1.101/16"];
            Gateway = "10.22.1.1";
            DNS = ["10.21.1.2" "10.21.1.3"];
            DHCP = "no";
          };
        };

        networking.hostName = "spetsctf-services";
        system.stateVersion = "25.05";
      };
    };
  };

  systemd.services.aulabokning = let
    aulabokningPath = inputs.aulabokning.packages."${pkgs.system}".default;
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
