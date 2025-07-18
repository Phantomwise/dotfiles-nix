{ pkgs, lib, config, ... }:

let
	systemdServices = import ./phantomwise-systemd.nix { inherit pkgs lib config; };
in

{
	home.packages = [ pkgs.atool pkgs.httpie ];

	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;

		shellAliases = {
			ll = "ls -alh";
			update = "sudo nixos-rebuild switch";
		};
		history.size = 10000;
	};

	# The state version is required and should stay at the version you
	# originally installed.
	#
	# This value determines the Home Manager release that your configuration is 
	# compatible with. This helps avoid breakage when a new Home Manager release 
	# introduces backwards incompatible changes. 
	#
	# You should not change this value, even if you update Home Manager. If you do 
	# want to update the value, then make sure to first check the Home Manager 
	# release notes. 
	home.stateVersion = "25.05";
}
