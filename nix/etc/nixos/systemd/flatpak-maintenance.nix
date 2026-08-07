.{ config, pkgs, ... }:

{

	systemd.services.flatpak-maintenance = {
		description = "Update Flatpaks and clean up unused dependencies";
		serviceConfig = {
			Type = "oneshot";
			ExecStart = [
				"${pkgs.flatpak}/bin/flatpak update -y"
				"${pkgs.flatpak}/bin/flatpak uninstall --unused -y"
			];
		};
	};

	systemd.timers.flatpak-maintenance = {
		description = "Run flatpak-maintenance weekly";
		wantedBy = [ "timers.target" ];
		timerConfig = {
			OnCalendar = "weekly";
			Persistent = true;
			RandomizedDelaySec = "1h";
		};
	};

}

