# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
	imports =
		[
			/etc/nixos/hardware-configuration.nix   # Include the results of the hardware scan.
			./environment.nix                       # Environment variables
			./fonts.nix                             # Fonts
			# ./home-manager.nix                    # Home manager config —deactivated, trying a user install instead
			./locale.nix                            # Locale settings
			./mounts-nfs.nix                        # NFS Mounts configuration
			# ./mounts-cifs.nix                     # CIFS Mounts configuration
			./networking.nix                        # Networking config
			./packages.nix                          # Packages declarations
			./packages-flatpak.nix                  # Flatpak packages
			./packages-games.nix                    # Packages declarations for games
			./packages-unstable.nix                 # Packages from the unstable repo
			./shellrc.nix                           # Bash and Zsh configuration
			# ./theming.nix                           # Themes configuration --> NOT WORKING
			./users.nix                             # Users configuration
			./systemd.nix                           # Systemd services and timers
			# ./systemd-services.nix                # Systemd services and timers
			./wayland.nix                           # Wayland portals configuration
			# ./config-cron.nix                     # Configuration for cron —DEPRECATED
			# "/etc/nixos/config-wireguard.nix"     # Configuration for wireguard —NOT WORKING: cuts all internet
			# "/etc/nixos/networking-wg-quick.nix"  # VPN config
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

	# Auto Update
	system.autoUpgrade.enable = true;
	system.autoUpgrade.dates = "weekly";

	# Auto Cleanup
	nix.gc.automatic = true;
	nix.gc.dates = "weekly";
	nix.gc.options = "--delete-older-than 7d";
	nix.settings.auto-optimise-store = true;

	# Bluetooth
	hardware.bluetooth.enable = true; # enables support for Bluetooth
	hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

	nix.settings.experimental-features = [ "nix-command" ];
	# nix.settings.experimental-features = [ "nix-command" "flakes" ];

	services.upower.enable = true;

	# Enable polkit
	security.polkit.enable = true;

	# Enable tlp for power management
	services.tlp = {
		enable = true;
		settings = {
				START_CHARGE_THRESH_BAT0 = 50;
				STOP_CHARGE_THRESH_BAT0 = 80;
		};
	};

	# Configure logind
	services.logind = {
		hibernateKey = "ignore";
		hibernateKeyLongPress = "ignore";
		lidSwitch = "suspend";
		lidSwitchDocked = "ignore";
		lidSwitchExternalPower = "suspend";
		# powerKey = "poweroff";
		# powerKeyLongPress = "ignore";
		suspendKey = "ignore";
		suspendKeyLongPress = "ignore";
	};

	# No idea what I'm doing, trying to fix graphics problem — TODO: check why it doesn't work
	# hardware.graphics = {
		# enable = true;
		# enable32Bit = true;
		# extraPackages = with pkgs; [
			# vaapiIntel          # Legacy Intel driver (Sandy/Ivy/Haswell)
			# libvdpau-va-gl      # Optional, bridges VA-API to VDPAU
		# ];
	# };

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
	services.openssh.enable = true;

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "25.05"; # Did you read the comment?

}
