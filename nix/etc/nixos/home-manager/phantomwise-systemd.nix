{ config, pkgs, ... }:

{
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
