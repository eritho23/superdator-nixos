# File containing deployments
{
  config,
  pkgs,
  ...
}: {
  # virtualisation.oci-containers = {
  # backend = "podman";
  # containers = {
  # "tvattstuga-app" = {
  # image = "ghcr.io/benib0/tvattstuga-app:1.2";
  # ports = [
  # "127.0.0.1:5000:3000"
  # "127.0.0.1:5001:4000"
  # ];
  # login = {
  # registry = "https://ghcr.io";
  # username = "benib0";
  # passwordFile = config.sops.secrets."beni_ghcr_token".path;
  # };
  # };
  # };
  # };

  containers.parkpappa = {
    autoStart = true;
    config = {
      config,
      pkgs,
      ...
    }: let
      pbDataDir = "/var/lib/pocketbase";
      pbListenAddr = "127.0.0.1:8090";
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
      systemd.services.parkpappa-pb = {
        unitConfig.description = "Pocketbase for parkpappa";
        serviceConfig = {
          ExecStartPre = "";
          ExecStart = "${pkgs.pocketbase}/bin/pocketbase serve --dir ${pbDataDir}/pb_data --publicDir ${pbDataDir}/pb_public --hooksDir ${pbDataDir}/pb_hooks --http ${pbListenAddr}";
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

  containers.zmartrest = {
    autoStart = true;
    config = {
      config,
      pkgs,
      ...
    }: let
      pbDataDir = "/var/lib/pocketbase";
      pbListenAddr = "127.0.0.1:8091";
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
      systemd.services.zmartrest-pb = {
        unitConfig.description = "Pocketbase for zmartrest";
        serviceConfig = {
          ExecStart = "${pkgs.pocketbase}/bin/pocketbase serve --dir ${pbDataDir}/pb_data --publicDir ${pbDataDir}/pb_public --hooksDir ${pbDataDir}/pb_hooks --http ${pbListenAddr}";
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
}
