{ config, pkgs, ... }:

{
	imports =
		[
			./systemd-clamav.nix
			./systemd/auto-update.nix
		];

}