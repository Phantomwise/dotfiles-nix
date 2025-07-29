{ config, pkgs, ... }:

{

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		gvfs
		gnome.gvfs
		ntfs3g
		(python3.withPackages (ps: [
			ps.requests
			ps.curl-cffi
			]))
		wine

		### CLI ###
		acpi
		brightnessctl
		bluetuith
		btop
		# cron # Set in config-cron.nix
		fastfetch
		figlet
		git
		gitmoji-cli
		intel-gpu-tools
		jq
		killall
		inotify-tools
		libnotify
		lm_sensors
		gnumake
		ncdu
		pulsemixer
		rclone
		rsync
		smartmontools
		steam-run
		stow
		tldr
		tree
		wl-clipboard

		### NETWORKING ###
		#  wget
		wg-netmanager
		wireguard-tools
		wireguard-ui
		protonvpn-gui

		### DESKTOP ###
		dunst
		(rofi-wayland.override { plugins = [ pkgs.rofi-calc pkgs.rofi-games ]; })
		rofimoji
		nemo-with-extensions
		nemo-fileroller

		### TERMINAL ###
		foot
		kitty

		### EDITORS ###
		featherpad
		kakoune
		micro-full
		# leafpad # error: 'leafpad' has been removed due to lack of maintenance upstream. Consider using 'xfce.mousepad' instead
		# ms-edit # not in repo
		vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

		### IMAGE ###
		gimp3-with-plugins
		grim
		imagemagick
		ksnip
		slurp
		sway-contrib.grimshot
		swaybg
		tiled
		xnviewmp

		### AUDIO & VIDEO ###
		abcde
		ani-cli
		asunder
		cdrkit
		ffmpeg
		# libation # moved to unstable
		mpc
		picard
		vlc
		(callPackage (import (builtins.fetchurl {
  url = "https://raw.githubusercontent.com/NixOS/nixpkgs/da2504032ba518133db8f559862d95bc95b1f81c/pkgs/by-name/yt/yt-dlp/package.nix";
  sha256 = "sha256:1ffrks7nk9s30g70k6b5qfyiy9ad8ydsqkq3y69f35pfxqblwfb7";
})) {})

		### MISC GUI ###
		bulky
		deltachat-desktop
		discord
		discord-canary
		freetube
		keepassxc
		libreoffice
		synology-drive-client
		zotero

			(vscode-with-extensions.override {
				vscodeExtensions = with vscode-extensions; [
					bodil.blueprint-gtk          # Gtk Bluprint language support
					ms-vscode.makefile-tools     # Makefile language support
					bbenoist.nix                 # Nix language support
					ms-python.python             # Python language support
					naumovs.color-highlight      # Color Highlight
					ms-azuretools.vscode-docker  # Docker
					donjayamanne.githistory      # Git History
					seatonjiang.gitmoji-vscode   # Gitmoji
					github.copilot               # GitHub Copilot

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
		];

	### DESKTOP ###

	programs.sway = {
		enable = true;
		wrapperFeatures.gtk = true; # need to set up the gtk portal somewhere else probably
		extraPackages = with pkgs; [
				swaybg
				swaylock
				swayidle
				swayimg
				# grim         # screenshot functionality
				# slurp        # screenshot functionality
				# wl-clipboard
				# make sure the default gnome icons are avaliable to gtk applications
				adwaita-icon-theme
			];
	};

	programs.waybar.enable = true;

	### MISC ###
	programs.firefox.enable = true;
	services.gvfs.enable = true;
}
