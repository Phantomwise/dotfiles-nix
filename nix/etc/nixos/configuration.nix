# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
	imports =
		[
			# Include the results of the hardware scan.
			./hardware-configuration.nix
			./environment.nix # Environment variables
			./fonts.nix # Fonts
			# ./home-manager.nix # Home manager config —deactivated, trying a user install instead
			./locale.nix # Locale settings
			./networking.nix # Networking config
			./packages.nix # Packages declarations
			./packages-flatpak.nix # Flatpak packages
			./packages-games.nix # Packages declarations for games
			./packages-unstable.nix # Packages from the unstable repo
			./shellrc.nix # Bash and Zsh configuration
			./users.nix # Users configuration
			# ./systemd-services.nix # Systemd services and timers
			./wayland.nix # Wayland portals configuration
			# ./config-cron.nix # Configuration for cron —DEPRECATED
			# "/etc/nixos/config-wireguard.nix" # Configuration for wireguard —NOT WORKING: cuts all internet
			# "/etc/nixos/networking-wg-quick.nix" # VPN config
		];

	# nixpkgs.overlays = [
		# (import ./overlays/libation-overlay.nix)
	# ];

	# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	# Use latest kernel.
	boot.kernelPackages = pkgs.linuxPackages_latest;

	networking.hostName = "nixos"; # Define your hostname.
	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


	hardware.bluetooth.enable = true; # enables support for Bluetooth
	hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

	nix.settings.experimental-features = [ "nix-command" ];
	# nix.settings.experimental-features = [ "nix-command" "flakes" ];

	services.upower.enable = true;

	# Enable polkit
	security.polkit.enable = true;

	# Failing to set color for sudo password prompts
	# security.sudo.extraConfig = ''
		# Defaults use_pty
		# Defaults passprompt="\033[1;34m[sudo] password for %p:\033[0m " # Not working, prints \033[1;34m[sudo] password for phantomwise:\033[0m
		# Defaults passprompt="^[1;34m[sudo] password for %p:^[0m " # Not working, prints ^[1;34m[sudo] password for phantomwise:^[0m
		# Defaults passprompt="␛[1;34m[sudo] password for %p:␛[0m " # Not working, prints ␛[1;34m[sudo] password for phantomwise:␛[0m
		# Defaults passprompt="\\e[1;34m[sudo] password for %p:\\e[0m " # Not working, prints \\e[1;34m[sudo] password for phantomwise:\\e[0m
	# '';

	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.mtr.enable = true;
	# programs.gnupg.agent = {
	#	 enable = true;
	#	 enableSSHSupport = true;
	# };

	# List services that you want to enable:

	# Enable the OpenSSH daemon.
	# services.openssh.enable = true;

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "25.05"; # Did you read the comment?

}
