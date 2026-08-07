{ config, pkgs, ... }:

{

	systemd.services.uptime-check = {
		description = "Send a notification to any active user session that has been running for over a week";
		serviceConfig.Type = "oneshot";
		script = ''
			readonly day_seconds=86400
			readonly threshold_days=7
			uptime_seconds=$(cut -d' ' -f1 /proc/uptime)
			uptime_seconds=''${uptime_seconds%.*}
			uptime_days=$((uptime_seconds / day_seconds))
			if [ "$uptime_seconds" -gt "$((day_seconds * threshold_days))" ]; then
				for session in $(loginctl list-sessions --no-legend | cut -d' ' -f1); do
					user=$(loginctl show-session "$session" -p Name --value)
					type=$(loginctl show-session "$session" -p Type --value)
					state=$(loginctl show-session "$session" -p State --value)
					if [ "$state" = "active" ] && { [ "$type" = "wayland" ] || [ "$type" = "x11" ]; }; then
						machinectl shell "$user"@ /run/current-system/sw/bin/notify-send "Uptime Warning" "The system has been running for ''${uptime_days} days. Please reboot."
					fi
				done
			fi
		'';
	};

	systemd.timers.uptime-check = {
		wantedBy = [ "timers.target" ];
		timerConfig = {
			# OnCalendar = "daily";
			OnCalendar = [ "04:00" "16:00" ];
			Persistent = true;
		};
	};

}

# TODO: Make the service execute a script that is in a separate file so there's some syntax highlighting, POSIX is making my eyes bleed
