{ config, ... }:

{
	# NAS:/volume1/temp
	fileSystems."/mnt/nas-temp" = {
		device = "//192.168.0.10/temp";
		fsType = "cifs";
		options = [
			"credentials=/etc/smb-nas-credentials"
			"vers=3.0"
			"uid=1000"        # UID 1000 Phantomwise
			"gid=100"         # GID 100 users
			"file_mode=0666"  # read & write for user, group, and others (no execute)
			"dir_mode=0777"   # read, write, execute for all
		];
	};
}
