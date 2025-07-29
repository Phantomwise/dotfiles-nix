{ config, pkgs, ... }:

{
	systemd.services.uptime-check = {
		description = "Check system uptime";
		serviceConfig = {
			Type = "oneshot";
			ExecStart = "/home/phantomwise/.local/bin/scripts/dunst/uptime.sh";
			User = "phantomwise";  # run as your user if needed
		};
	};

	systemd.timers.uptime-check = {
		description = "Run uptime check every 12 hours";
		wants = [ "uptime-check.service" ];
		timerConfig = {
			OnCalendar = "hourly";
			# To run every 12 hours exactly at 0:00 and 12:00, use:
			# OnCalendar = "0/12:00:00";
			OnCalendar = "0,12:00:00"; 
			Persistent = true; # run missed jobs if system was off
		};
		wantedBy = [ "timers.target" ];
	};

	systemd.services.rclone-sync = {
		description = "Sync to NAS with rclone";
		serviceConfig = {
			Type = "oneshot";
			ExecStart = "${pkgs.rclone}/bin/rclone sync -v /home/phantomwise/Sync/SynologyDrive NAS:personal/Sync/Dell-Latitude-E5530-Nix-Rclone";
			User = "phantomwise";
		};
	};

	systemd.timers.rclone-sync = {
		description = "Run rclone sync every 30 minutes";
		wants = [ "rclone-sync.service" ];
		timerConfig = {
			OnCalendar = "minutely";
			OnUnitActiveSec = "30m";  # run every 30 minutes after last run
			Persistent = true;
		};
		wantedBy = [ "timers.target" ];
	};
}
