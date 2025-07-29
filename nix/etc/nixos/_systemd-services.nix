{ config, pkgs, ... }:

{

	systemd.timers."battery-alert" = {
		wantedBy = [ "timers.target" ];
			timerConfig = {
				OnBootSec = "1m";
				OnUnitActiveSec = "1m";
	`			Unit = "battery-alert.service";
			};
	};

	systemd.services."battery-alert" = {
		ExecStart = "/home/phantomwise/.local/bin/scripts/dunst/battery-alert.sh";
		serviceConfig = {
			Type = "oneshot";
			User = "phantomwise";
		};
	};

	systemd.user.services.rclone-nas = {
		description = "Sync to NAS with Rclone";
		serviceConfig = {
			Type = "oneshot";
			ExecStart = "${pkgs.libnotify}/bin/notify-send test";
		};
	};

	systemd.user.timers.rclone-nas = {
		wantedBy = [ "timers.target" ]; # enable automatically
		timerConfig = {
			OnBootSec = "5m";
			OnUnitActiveSec = "5m";
			Unit = "rclone-nas.service";
		};
	};

}