# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

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

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak";
  };

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.phantomwise = {
		isNormalUser = true;
		description = "Phantomwise";
		extraGroups = [ "networkmanager" "wheel" ];
		packages = with pkgs; [];
		shell = pkgs.zsh;
	};

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		cron
		git
		gitmoji-cli
		gvfs
		gnome.gvfs
		inotify-tools
		stow
		wl-clipboard
		# zsh
		zsh-autocomplete
		zsh-autosuggestions
		#  wget
		### COMPOSITOR ###
		dunst
		rofi-wayland
		# waybar
		nemo
		### TERMINAL ###
		foot
		kitty
		### EDITORS ###
		featherpad
		kakoune
		micro
		# leafpad # error: 'leafpad' has been removed due to lack of maintenance upstream. Consider using 'xfce.mousepad' instead
		# ms-edit
		# vscode-with-extensions
		vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
		### FONTS ###
		font-awesome
		nerd-fonts._0xproto
		nerd-fonts.geist-mono
		nerd-fonts.terminess-ttf
		### MISC ###
		discord-canary
		keepassxc
		libation
		synology-drive-client

			(vscode-with-extensions.override {
				vscodeExtensions = with vscode-extensions; [
					bbenoist.nix
					ms-python.python
					ms-azuretools.vscode-docker
					ms-vscode-remote.remote-ssh
				] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
					{
						name = "remote-ssh-edit";
						publisher = "ms-vscode-remote";
						version = "0.47.2";
						sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
					}
				];
			})

		vscode-extensions.seatonjiang.gitmoji-vscode
		];

	programs.sway.enable = true;
	programs.waybar.enable = true;

	programs.firefox.enable = true;

	programs.zsh.enable = true;
	programs.zsh.enableCompletion = true;
	programs.zsh.autosuggestions.enable = true;
	programs.zsh.syntaxHighlighting.enable = true;

	services.upower.enable = true;

	users.defaultUserShell = pkgs.zsh;

	environment.sessionVariables.NIXOS_OZONE_WL = "1";

	# This is using a rec (recursive) expression to set and access XDG_BIN_HOME within the expression
	# For more on rec expressions see https://nix.dev/tutorials/first-steps/nix-language#recursive-attribute-set-rec
	environment.sessionVariables = rec {
		XDG_CACHE_HOME  = "$HOME/.cache";
		XDG_CONFIG_HOME = "$HOME/.config";
		# XDG_DATA_HOME   = "$HOME/.local/share";
		# XDG_STATE_HOME  = "$HOME/.local/state";

		# Not officially in the specification
		# XDG_BIN_HOME    = "$HOME/.local/bin";
		# PATH = [ 
			# "${XDG_BIN_HOME}"
		# ];
	};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
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
