{ config, pkgs, ... }:

{

	systemd.services.test-notify-send = {
		description = "Send a notification to any active user session";
		serviceConfig.Type = "oneshot";
		script = ''
			for session in $(loginctl list-sessions --no-legend | cut -d' ' -f1); do
#			for session in $(loginctl list-sessions --no-legend | awk '{print $1}'); do
				user=$(loginctl show-session "$session" -p Name --value)
				type=$(loginctl show-session "$session" -p Type --value)
				state=$(loginctl show-session "$session" -p State --value)
				if [ "$state" = "active" ] && { [ "$type" = "wayland" ] || [ "$type" = "x11" ]; }; then
					machinectl shell "$user"@ /run/current-system/sw/bin/notify-send "Test"
				fi
			done
		'';
	};

	systemd.timers.test-notify-send = {
		wantedBy = [ "timers.target" ];
		timerConfig = {
			OnCalendar = "minutely";
			Persistent = true;
		};
	};

}
