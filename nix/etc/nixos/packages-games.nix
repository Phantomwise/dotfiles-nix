{ config, pkgs, ... }:

{

	environment.systemPackages = with pkgs; [

		### EMULATORS ###
		dosbox # DOS Emulator
		mgba # GBA Emulator
		vbam # GBA Emulator
		desmume # NDS Emulator
		melonDS # NDS Emulator
		cemu # Wii U Emulator
		dolphin-emu # Gamecube/Wii/Triforce Emulator for x86_64 and ARMv8
		# dolphin-emu-primehack

		### STORES ###
		lutris

		### TOOLS
		gamescope
		protontricks
		winetricks

		### GAMES ###
		cataclysm-dda
		# keeperrl # Error

	];

	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
		dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
		localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
	};

}
