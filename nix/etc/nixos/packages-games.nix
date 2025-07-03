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

		### GAMES ###
		cataclysm-dda
		# keeperrl # Error

	];
}
