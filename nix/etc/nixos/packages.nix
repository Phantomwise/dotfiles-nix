{ config, pkgs, ... }:

{

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# Enable flatpaks
	services.flatpak.enable = true;
	systemd.services.flatpak-repo = {
		wantedBy = [ "multi-user.target" ];
		path = [ pkgs.flatpak ];
		script = ''
			flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
		'';
	};

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		gvfs
		gnome.gvfs
		# zsh
		zsh-autocomplete
		zsh-autosuggestions
		#  wget

		### CLI ###
		ani-cli
		brightnessctl
		bluetuith
		btop
		cron
		fastfetch
		ffmpeg
		figlet
		git
		gitmoji-cli
		killall
		inotify-tools
		libnotify
		gnumake
		ncdu
		pulsemixer
		rsync
		smartmontools
		steam-run
		stow
		tldr
		tree
		wine
		wl-clipboard
		yt-dlp

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
		asunder
		mpc
		vlc

		### MISC GUI ###
		deltachat-desktop
		discord
		discord-canary
		keepassxc
		libation
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

	### SHELL ###
	programs.zsh.enable = true;
	programs.zsh.enableCompletion = true;
	programs.zsh.autosuggestions.enable = true;
	programs.zsh.syntaxHighlighting.enable = true;

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

}
