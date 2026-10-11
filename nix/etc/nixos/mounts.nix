{ config, ... }:

{
	fileSystems."/mnt/wdc20tb" = {
		device = "/dev/disk/by-uuid/7FA5-3D19";
		fsType = "exfat";
		options = [
			"defaults"
			"nofail"          # do not fail boot
			"uid=1000"
			"gid=100"
		];
	};
}
