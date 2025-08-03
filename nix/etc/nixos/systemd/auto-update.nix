{ config, pkgs, ... }:

{

	systemd.timers.nixos-auto-update = {
		wantedBy = [ "timers.target" ];
		timerConfig = {
			# OnCalendar = "weekly";
			OnCalendar = "Mon 12:00";
			Persistent = true;
		};
	};

	systemd.services.nixos-auto-update = {
		script = ''
			echo "=== $(date) ===" > /var/log/nixos-upgrade.log
			nixos-rebuild switch --upgrade > /var/log/nixos-upgrade.log 2>&1
		'';
		serviceConfig = {
			Type = "oneshot";
			User = "root";
		};
	};

}