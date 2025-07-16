{ config, pkgs, lib, ... }:

let
	home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
in
{
	imports =
		[
			(import "${home-manager}/nixos")
		];

	home-manager.users.phantomwise = { pkgs, ... }:
	{
		home.packages = [ pkgs.atool pkgs.httpie ];
		programs.zsh.enable = true;
	
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
	};

}