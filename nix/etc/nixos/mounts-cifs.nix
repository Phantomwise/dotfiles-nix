{ config, ... }:

let
	ips = import ./var/ip.nix;
in

{
	# NAS:/volume1/temp
	fileSystems."/mnt/nas-temp" = {
		device = "//${ips.NAS}/temp";
		fsType = "cifs";
		options = [
			"credentials=/etc/smb-nas-credentials"
			"vers=3.0"
			"uid=1000"        # UID 1000 Phantomwise
			"gid=100"         # GID 100 users
			"file_mode=0666"  # read & write for user, group, and others (no execute)
			"dir_mode=0777"   # read, write, execute for all
			"noauto"          # do not automount, needs `sudo mount /mnt/nas-temp`
			"nofail"          # do not fail boot
		];
	};
}
