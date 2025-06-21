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
		cron
		fastfetch
		ffmpeg
		figlet
		git
		gitmoji-cli
		killall
		inotify-tools
		rsync
		steam-run
		stow
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
		micro
		# leafpad # error: 'leafpad' has been removed due to lack of maintenance upstream. Consider using 'xfce.mousepad' instead
		# ms-edit # not in repo
		vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.

		### IMAGE ###
		gimp3-with-plugins
		grim
		ksnip
		slurp
		sway-contrib.grimshot
		swaybg
		xnviewmp

		### VIDEO ###
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
