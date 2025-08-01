# File containing deployments
{
  config,
  pkgs,
  inputs,
  ...
}: {
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
        version = "0.26.4";
        src = pkgs.fetchFromGitHub {
          owner = "pocketbase";
          repo = "pocketbase";
          rev = "v${version}";
          hash = "sha256-rNosfeiuXsn2x8Ae7WIZLmF7njsgi8fJ1Ze1njYQSY0=";
        };
        vendorHash = "sha256-9TuKYXZyyfVaow/5SW0rbYlIs8XiNF1hmkmHZT9J2O0=";
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
      systemd.services.justcount-pb = {
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
    };
  };

  # containers.fardtjanst = {
  #   autoStart = true;
  #   config = {
  #     config,
  #     pkgs,
  #     ...
  #   }: let
  #     pbDataDir = "/var/lib/pocketbase";
  #     pbListenAddr = "127.0.0.1:8093";
  #     pbPackage = pkgs.pocketbase.overrideAttrs (f: rec {
  #       version = "0.26.4";
  #       src = pkgs.fetchFromGitHub {
  #         owner = "pocketbase";
  #         repo = "pocketbase";
  #         rev = "v${version}";
  #         hash = "sha256-rNosfeiuXsn2x8Ae7WIZLmF7njsgi8fJ1Ze1njYQSY0=";
  #       };
  #       vendorHash = "sha256-9TuKYXZyyfVaow/5SW0rbYlIs8XiNF1hmkmHZT9J2O0=";
  #     });
  #   in {
  #     system.stateVersion = "23.11";
  #     environment.systemPackages = with pkgs; [pocketbase];
  #     users.users.pocketbase = {
  #       isSystemUser = true;
  #       home = pbDataDir;
  #       shell = "/run/current-system/sw/bin/nologin";
  #       group = "pocketbase";
  #       createHome = true;
  #     };
  #     users.groups.pocketbase = {};
  #     systemd.services.fardtjanst-pb = {
  #       unitConfig.description = "Pocketbase for fardtjanst";
  #       serviceConfig = {
  #         ExecStart = "${pbPackage}/bin/pocketbase serve --dir ${pbDataDir}/pb_data --publicDir ${pbDataDir}/pb_public --hooksDir ${pbDataDir}/pb_hooks --http ${pbListenAddr}";
  #         Restart = "always";
  #         RestartSec = "5s";
  #         Type = "simple";
  #         User = "pocketbase";
  #         Group = "pocketbase";
  #       };
  #       wantedBy = ["multi-user.target"];
  #     };
  #   };
  # };

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
}
