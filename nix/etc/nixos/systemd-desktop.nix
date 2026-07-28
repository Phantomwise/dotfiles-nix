{ config, pkgs, ... }:

{
	imports =
		[
			./systemd/slices.nix
		];

}