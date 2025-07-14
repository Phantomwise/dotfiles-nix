{ config, lib, pkgs, ... }:

{

	# Enable networking
	networking.networkmanager.enable = true;
	# Enable wireguard
	networking.wireguard.enable = true;

	# Enable systemd resolved
	services.resolved.enable = true;

}
