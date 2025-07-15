{ config, lib, pkgs, ... }:

{

	# Enable networking
	networking.networkmanager.enable = true;
	# Enable wireguard
	networking.wireguard.enable = true;

	# Enable systemd resolved
	services.resolved.enable = true;

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

}
