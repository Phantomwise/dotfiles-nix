{ config, ... }:

{
	# optional, but ensures rpc-statsd is running for on demand mounting
	boot.supportedFilesystems = [ "nfs" ];

	# NAS:/volume1/temp
	fileSystems."/mnt/nas-temp" = {
		device = "192.168.0.10:/volume1/temp";
		fsType = "nfs";
	};
}
