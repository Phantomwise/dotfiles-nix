{
  description = "Override libation to build from latest git";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    libation_src = {
      url = "https://github.com/rmcrackan/Libation";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, libation_src }: let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  in {
    defaultPackage.x86_64-linux = pkgs.libation.overrideAttrs (oldAttrs: {
      src = libation_src;
      version = "nightly-${libation_src.shortRev or "src"}";
    });
  };
}

