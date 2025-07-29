{ config, pkgs, ... }:

{
	imports =
		[
			./systemd-clamav.nix
		];

}