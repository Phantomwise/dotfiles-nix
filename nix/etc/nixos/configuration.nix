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
			# ./mounts-nfs.nix                        # NFS Mounts configuration
			./mounts-cifs.nix                       # CIFS Mounts configuration
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
			./unsorted.nix                          # Other stuff
		];

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "25.05"; # Did you read the comment?

}
