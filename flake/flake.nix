{
	description = "Yet another attempt at flakes please please work this time T_T";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
	};

	outputs = { self, nixpkgs }:
	{
		nixosConfigurations = {
			laptop = nixpkgs.lib.nixosSystem {
				# system = "x86_64-linux";
				modules = [
					../nix/etc/nixos/configuration.nix
				];
			};
		};

	};
}
