let
  lib = import <nixpkgs/lib>;
in

{
	# MAC Addresses

	# Bluetooth Audio Devices
	EDIFIER_R1700BT = lib.strings.trim (builtins.readFile /etc/nixos/secrets/MAC/bluetooth/EDIFIER_R1700BT.txt);
	JBES_A9         = lib.strings.trim (builtins.readFile /etc/nixos/secrets/MAC/bluetooth/JBES_A9.txt);
}
