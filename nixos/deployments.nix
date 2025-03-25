# File containing deployments
{
  config,
  pkgs,
  ...
}: {
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

  # containers.justcount = {
  # autoStart = true;
  # config = {
  # config,
  # pkgs,
  # ...
  # }: let
  # pbDataDir = "/var/lib/pocketbase";
  # pbListenAddr = "127.0.0.1:8092";
  # in {
  # system.stateVersion = "23.11";
  # environment.systemPackages = with pkgs; [pocketbase];
  # users.users.pocketbase = {
  # isSystemUser = true;
  # home = pbDataDir;
  # shell = "/run/current-system/sw/bin/nologin";
  # group = "pocketbase";
  # createHome = true;
  # };
  # users.groups.pocketbase = {};
  # systemd.services.zmartrest-pb = {
  # unitConfig.description = "Pocketbase for zmartrest";
  # serviceConfig = {
  # ExecStart = "${pkgs.pocketbase}/bin/pocketbase serve --dir ${pbDataDir}/pb_data --publicDir ${pbDataDir}/pb_public --hooksDir ${pbDataDir}/pb_hooks --http ${pbListenAddr}";
  # Restart = "always";
  # RestartSec = "5s";
  # Type = "simple";
  # User = "pocketbase";
  # Group = "pocketbase";
  # };
  # wantedBy = ["multi-user.target"];
  # };
  # };
  # };
}
