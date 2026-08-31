let
  lib = import <nixpkgs/lib>;
in

{
	# IP Addresses
	NAS = lib.strings.trim (builtins.readFile /etc/nixos/secrets/IP/DS1621.txt);
}
