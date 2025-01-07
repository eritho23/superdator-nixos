# File containing deployments
{config, pkgs, ...}:
{
    containers.parkpappa = {
        config = {config, pkgs, ...}: {
		system.stateVersion = "23.11";
		users.users.pocketbase = {
			isSystemUser = true;
			home = "/var/lib/pocketbase";
			shell = "/run/current-system/sw/bin/nologin";
			group = "pocketbase";
		};
		users.groups.pocketbase = {};
		systemd.services.parkpappa-pb = {
			unitConfig.description = "Pocketbase for parkpappa";
			serviceConfig = {
				ExecStart = "${pkgs.pocketbase}/bin/pocketbase serve";
				Restart = "always";
				RestartSec = "5s";
				Type = "simple";
				User = "pocketbase";
				Group = "pocketbase";

			};
			wantedBy = [ "multi-user.target" ];
		};	
	};
    };
}
