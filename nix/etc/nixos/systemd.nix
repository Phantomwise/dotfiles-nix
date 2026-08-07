{ config, pkgs, ... }:

{
	imports =
		[
			./systemd/clamav.nix
			./systemd/uptime-check.nix
			# ./systemd/auto-update.nix
		];

}