{ config, pkgs, ... }:

{
	imports =
		[
			./systemd/clamav.nix
			./systemd/flatpak-maintenance.nix
			./systemd/uptime-check.nix
			# ./systemd/auto-update.nix
		];

}