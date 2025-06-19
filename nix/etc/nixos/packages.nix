{ config, pkgs, ... }:

{

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

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
		cron
		git
		gitmoji-cli
		killall
		inotify-tools
		steam-run
		stow
		wl-clipboard

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

		### MISC GUI ###
		deltachat-desktop
		discord-canary
		keepassxc
		libation
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
	programs.sway.enable = true;
	programs.waybar.enable = true;

	### MISC ###
	programs.firefox.enable = true;

}
