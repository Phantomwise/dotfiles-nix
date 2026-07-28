{ config, pkgs, ... }:

{

	systemd.slices."user" = {
		sliceConfig = {
			MemoryHigh = "50G";
			MemoryMax = "55G";
			MemorySwapMax = "10G";
		};
	};

}
