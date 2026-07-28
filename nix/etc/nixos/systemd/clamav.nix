{ config, pkgs, ... }:

{
	services.clamav = {
		daemon.enable = true;
		updater.enable = true;
		updater.settings = {
			DatabaseMirror = [ "database.clamav.net" ];
			DatabaseDirectory = "/var/lib/clamav";
		};
	};

	# Optional: Open ports or configure logging
	# networking.firewall.allowedTCPPorts = [ 3310 ]; # clamd port if needed
}
