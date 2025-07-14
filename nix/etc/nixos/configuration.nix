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
			./locale.nix # Locale settings
			./packages.nix # Packages declarations
			./packages-games.nix # Packages declarations for games
			# ./config-cron.nix # Configuration for cron —DEPRECATED
			./config-wireguard.nix # Configuration for wireguard
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

	# Enable networking
	networking.networkmanager.enable = true;

	hardware.bluetooth.enable = true; # enables support for Bluetooth
	hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.phantomwise = {
		isNormalUser = true;
		description = "Phantomwise";
		extraGroups = [ "networkmanager" "wheel" ];
		packages = with pkgs; [];
		shell = pkgs.zsh;
	};

	# nix.settings.experimental-features = [ "nix-command" "flakes" ];

	services.upower.enable = true;

	users.defaultUserShell = pkgs.zsh;

	xdg.portal = {
		enable = true;
		wlr.enable = true;
		# gtk portal needed to make firefox happy
		extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
		# gtkUsePortal = true;
			# error:
			# The option definition `xdg.portal.gtkUsePortal' in `/home/phantomwise/SynologyDrive/dotfiles-nix/nix/etc/nixos/configuration.nix' no longer has any effect; please remove it.
			# This option has been removed due to being unsupported and discouraged by the GTK developers.
	};

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

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "25.05"; # Did you read the comment?

}
