{ config, pkgs, ... }:

{
	fonts.packages = with pkgs; [
		noto-fonts
		noto-fonts-cjk-sans
		noto-fonts-emoji
		liberation_ttf
		fira-code
		fira-code-symbols
		font-awesome
		nerd-fonts._0xproto
		nerd-fonts.hack
		nerd-fonts.geist-mono
		nerd-fonts.terminess-ttf
	];

}
