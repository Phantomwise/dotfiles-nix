let
  lib = import <nixpkgs/lib>;
in

{
	# MAC Addresses

	# Bluetooth Audio Devices
	EDIFIER_R1700BT = lib.strings.trim (builtins.readFile /etc/nixos/secrets/MAC/bluetooth/EDIFIER_R1700BT.txt);
	JBES_A9_B       = lib.strings.trim (builtins.readFile /etc/nixos/secrets/MAC/bluetooth/JBES_A9-Black.txt);
	JBES_A9_W       = lib.strings.trim (builtins.readFile /etc/nixos/secrets/MAC/bluetooth/JBES_A9-White.txt);
}
