{ config, lib, pkgs, ... }:

{

	environment.systemPackages = with pkgs; [
		zsh-autocomplete
		zsh-autosuggestions
		zsh-syntax-highlighting
		];

	programs.zsh.enable = true;
	programs.zsh.enableCompletion = true;
	programs.zsh.autosuggestions.enable = true;
	programs.zsh.syntaxHighlighting.enable = true;

	users.defaultUserShell = pkgs.zsh;

}
