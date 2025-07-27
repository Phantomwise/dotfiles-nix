{ config, pkgs, ... }:

let
	unstable = import <nixos-unstable> {
		config = config.nixpkgs.config;  # Reuse the same config already defined
		system = pkgs.system;            # Reuse the same architecture already defined
	};
in {

	environment.systemPackages = with unstable; [
		# unstable packages
		libation
	];
}
