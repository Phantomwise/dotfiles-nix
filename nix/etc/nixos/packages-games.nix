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
		angband                  # Single-player roguelike dungeon exploration game
		cataclysm-dda            # Free, post apocalyptic, zombie infested rogue-like
		crossfire-client         # GTKv2 client for the Crossfire free MMORPG
		exult                    # Recreation of Ultima VII for modern operating systems
		flare                    # Fantasy action RPG using the FLARE engine
		freedroidrpg             # Isometric 3D RPG similar to game Diablo
		narsil                   # Unofficial rewrite of Sil, a roguelike influenced by Angband
		nethack                  # Rogue-like game
		nethack-qt               # Rogue-like game
		unnethack                # Fork of NetHack
		rpg-cli                  # Your filesystem as a dungeon
		sil-q                    # Roguelike game set in the First Age of Middle-earth
		tome2                    # Dungeon crawler similar to Angband, based on the works of Tolkien
		unciv                    # Open-source Android/Desktop remake of Civ V
		# keeperrl # Error

	];

	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
		dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
		localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
	};

}
