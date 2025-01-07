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
    in {
      system.stateVersion = "23.11";
      users.users.pocketbase = {
        isSystemUser = true;
        home = pbDataDir;
        shell = "/run/current-system/sw/bin/nologin";
        group = "pocketbase";
      };
      users.groups.pocketbase = {};
      systemd.services.parkpappa-pb = {
        unitConfig.description = "Pocketbase for parkpappa";
        serviceConfig = {
          ExecStart = "${pkgs.pocketbase}/bin/pocketbase serve --dir ${pbDataDir}/pb_data --publicDir ${pbDataDir}/pb_public --hooksDir ${pbDataDir}/pb_hooks";
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
