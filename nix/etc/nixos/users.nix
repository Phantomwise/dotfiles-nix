{ config, lib, pkgs, ... }:

{

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.phantomwise = {
		isNormalUser = true;
		description = "Phantomwise";
		extraGroups = [ "networkmanager" "wheel" ];
		packages = with pkgs; [];
		shell = pkgs.zsh;
	};

}
