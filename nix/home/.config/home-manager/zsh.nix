{ config, pkgs, ... }:

{
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;
		dotDir = ".config/zsh";
		history.ignoreAllDups = true;
		# history.path = "${config.home.homeDirectory}/.config/zsh/.zsh_history";
		history.size = 10000;
		shellAliases = {
			"~" = "cd ~";
			".." = "cd ..";
			cdd = "cd ~/Sync/SynologyDrive/dotfiles-nix/nix/";
			cds = "cd ~/Sync/SynologyDrive/";
			ll = "ls -alh";
			hh = "home-manager switch";
			update = "sudo nixos-rebuild switch";
		};
	};
}
