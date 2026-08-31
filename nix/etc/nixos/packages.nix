{ config, pkgs, ... }:

{

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	nixpkgs.config.permittedInsecurePackages = [
		"ventoy-1.1.12"
		"mbedtls-2.28.10"
	];

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [

		### UNSORTED ###
		appimage-run                # 
		# cron                      # Daemon for running commands at specific times
		b3sum                       # BLAKE3 cryptographic hash function
		dig                         # Domain name server
		figlet                      # Program for making large letters out of ordinary text
		inotify-tools               #
		mesa-demos                  # Collection of demos and test programs for OpenGL and Mesa
		steam-run                   # Run commands in the same FHS environment that is used for Steam
		tldr                        # Simplified and community-driven man pages
		ventoy-full                 # New Bootable USB Solution
		wine                        # Open Source implementation of the Windows API on top of X, OpenGL, and Unix
		libgourou                   # Implementation of Adobe's ADEPT protocol for ePub/PDF DRM
		monolith                    # Bundle any web page into a single HTML file
		wget                        # Tool for retrieving files using HTTP, HTTPS, and FTP
		nvd                         # Nix/NixOS package version diff tool
		font-manager                # Simple font management for GTK desktop environments
		nushell                     # Modern shell written in Rust
		p7zip                       # New p7zip fork with additional codecs and improvements (forked from https://sourceforge.net/projects/p7zip/)
		unzip                       # Extraction utility for archives compressed in .zip format
		vulkan-tools                # Khronos official Vulkan Tools and Utilities
		protonup-rs                 # Rust app to install and update GE-Proton for Steam, and Wine-GE for Lutris
		xdg-user-dirs               # Tool to help manage well known user directories like the desktop folder and the music folder
		pciutils                    # Collection of programs for inspecting and manipulating configuration of PCI devices

		### TOOLS ###
		brightnessctl               # This program allows you read and control device brightness
		detox                       # Utility designed to clean up filenames
		file                        # Program that shows the type of files
		fzf                         # Command-line fuzzy finder written in Go
		killall                     #
		gnumake                     # Tool to control the generation of non-source files from sources
		rclone                      # Command line program to sync files and directories to and from major cloud storage
		ripgrep                     # Utility that combines the usability of The Silver Searcher with the raw speed of grep
		rsync                       # Fast incremental file transfer utility
		sd                          # Intuitive find & replace CLI (sed alternative)
		stow                        # Tool for managing the installation of multiple software packages in the same run-time directory tree
		tlp                         # Advanced Power Management for Linux
		tree                        # Command to produce a depth indented directory listing

		### LIBRARIES ###
		libnotify                   # Library that sends desktop notifications to a notification daemon
		libsecret                   # Library for storing and retrieving passwords and other secrets
		libva-utils                 # Collection of utilities and examples for VA-API
		libGLU                      # OpenGL utility library
		mesa                        # Open source 3D graphics library

		### FILESYSTEMS ###
		cifs-utils                  # Tools for managing Linux CIFS client filesystems
		exfatprogs                  # exFAT filesystem userspace utilities
		e2fsprogs                   # Tools for creating and checking ext2/ext3/ext4 filesystems
		gvfs                        # Virtual Filesystem support library
		gnome.gvfs                  # Virtual Filesystem support library (full GNOME support)
		nfs-utils                   # Linux user-space NFS utilities
		ntfs3g                      # FUSE-based NTFS driver with full write support
		ntfsprogs                   # FUSE-based NTFS driver with full write support
		samba                       # Standard Windows interoperability suite of programs for Linux and Unix

		### MONITORING ###
		acpi                        # Show battery status and other ACPI information
		btop                        # Monitor of resources
		intel-gpu-tools             # Tools for development and testing of the Intel DRM driver
		iotop                       # Tool to find out the processes doing the most IO
		fastfetch                   # An actively maintained, feature-rich and performance oriented, neofetch like system information tool
		lm_sensors                  # Tools for reading hardware sensors
		ncdu                        # Disk usage analyzer with an ncurses interface
		nethogs                     # Small 'net top' tool, grouping bandwidth by process
		smartmontools               # Tools for monitoring the health of hard drives
		sysstat                     # Collection of performance monitoring tools for Linux (such as sar, iostat and pidstat)

		### NETWORKING ###
		# bluetuith                 # TUI-based bluetooth connection manager
		ethtool                     # Utility for controlling network drivers and hardware
		iperf                       # Tool to measure IP bandwidth using UDP or TCP
		iw                          # Tool to use nl80211
		net-tools                   # Set of tools for controlling the network subsystem in Linux
		nmap                        # Free and open source utility for network discovery and security auditing
		proton-vpn                  # Proton VPN GTK app for Linux
		#  wget                     # Tool for retrieving files using HTTP, HTTPS, and FTP
		wg-netmanager               # Wireguard network manager
		wireguard-tools             # Tools for the WireGuard secure network tunnel
		wireguard-ui                # Web user interface to manage your WireGuard setup

		### SECURITY ###
		clamav                      # Antivirus engine designed for detecting Trojans, viruses, malware and other malicious threats

		### FILE MANIPULATION ###
		exiftool                    # Tool to read, write and edit EXIF meta information
		html-xml-utils              # Utilities for manipulating HTML and XML files
		pandoc                      # Conversion between documentation formats
		xmlstarlet                  # Command line tool for manipulating and querying XML data

		### GRAPHICAL SESSION ###
		dunst                       # Lightweight and customizable notification daemon
		(rofi.override { plugins = [ pkgs.rofi-calc pkgs.rofi-games ]; })
		rofimoji                    # Simple emoji and character picker for rofi
		grim                        # Grab images from a Wayland compositor
		slurp                       # Select a region in a Wayland compositor
		swayimg                     # Image viewer for Sway/Wayland #!
		wl-clipboard                # Command-line copy/paste utilities for Wayland
		nemo-with-extensions        # File browser for Cinnamon
		nemo-fileroller             # Nemo file roller extension # TO CHECK IF NEEDED
		xdg-desktop-portal-wlr      # xdg-desktop-portal backend for wlroots

		### TERMINAL ###
		foot                        # Fast, lightweight and minimalistic Wayland terminal emulator
		kitty                       # The fast, feature-rich, GPU based terminal emulator

		### EDITORS ###
		featherpad                  # Lightweight Qt5 Plain-Text Editor for Linux
		kakoune                     # Vim inspired text editor #!
		# komodo                      # Tool to build and deploy software on many servers
		micro-full                  # Modern and intuitive terminal-based text editor
		# leafpad                   # error: 'leafpad' has been removed due to lack of maintenance upstream. Consider using 'xfce.mousepad' instead
		# ms-edit                   # not in repo
		scite                       # SCIntilla based Text Editor
		vim                         # Most popular clone of the VI editor

		### IMAGE ###
		ascii-draw                  # Draw diagrams or anything using only ASCII
		digikam                     # Photo management application
		gimp3-with-plugins          # GNU Image Manipulation Program
		imagemagick                 # Software suite to create, edit, compose, or convert bitmap images
		inkscape                    # Vector graphics editor
		ksnip                       # Cross-platform screenshot tool with many annotation features
		libavif                     # C implementation of the AV1 Image File Format
		libwebp                     # Tools and library for the WebP image format
		libresprite                 # Animated sprite editor & pixel art tool, fork of Aseprite
		# pikopixel                 # Application for drawing and editing pixel-art images
		                            # Not working with Sway, makes Waybar freeze
		pinta                       # Drawing/editing program modeled after Paint.NET
		sway-contrib.grimshot       # Helper for screenshots within sway
		tiled                       # Free, easy to use and flexible tile map editor
		xnviewmp                    # Efficient multimedia viewer, browser and converter

		### AUDIO & VIDEO ###
		ani-cli                     # Cli tool to browse and play anime
		# beets                     # Music tagger and library organizer
		                            # error: Package ‘python3.13-beets-2.5.1’ in /nix/store/[...]/beets/default.nix:483 is marked as insecure, refusing to evaluate.
		ffmpeg                      # Complete, cross-platform solution to record, convert and stream audio and video
		finamp                      # Open source Jellyfin music player
		gpac                        # Open Source multimedia framework for research and academic purposes
		# jellyfin-media-player       # Jellyfin Desktop Client based on Plex Media Player
		# libation # moved to unstable
		mediainfo                   # Supplies technical and tag information about a video or audio file
		mkvtoolnix                  # Cross-platform tools for Matroska
		mpc                         # Minimalist command line interface to MPD
		mpv                         # General-purpose media player, fork of MPlayer and mplayer2
		picard                      # picard
		pulsemixer                  # Cli and curses mixer for pulseaudio
		tageditor                   # Tag editor with Qt GUI and command-line interface supporting MP4/M4A/AAC (iTunes), ID3, Vorbis, Opus, FLAC and Matroska
		vlc                         # Cross-platform media player and streaming server
		# yt-dlp
		# (callPackage (import (builtins.fetchurl {
			# url = "https://raw.githubusercontent.com/NixOS/nixpkgs/da2504032ba518133db8f559862d95bc95b1f81c/pkgs/by-name/yt/yt-dlp/package.nix";
			# sha256 = "sha256:1ffrks7nk9s30g70k6b5qfyiy9ad8ydsqkq3y69f35pfxqblwfb7";
			# })) {})

		### AUDIO & VIDEO : RIP ###
		abcde                       # Command-line audio CD ripper
		asunder                     # Graphical Audio CD ripper and encoder for Linux
		cdparanoia                  # Tool and library for reading digital audio from CDs
		cdrdao                      # Tool for recording audio or data CD-Rs in disk-at-once (DAO) mode
		cdrkit                      # Portable command-line CD/DVD recorder software, mostly compatible with cdrtools
		dvdbackup                   # Tool to rip video DVDs from the command line
		handbrake                   # Tool for converting video files and ripping DVDs
		libdvdcss                   # Library for decrypting DVDs
		makemkv                     # Convert blu-ray and dvd to mkv
		rubyripper                  # High quality CD audio ripper
		whipper                     # CD ripper aiming for accuracy over speed

		### MISC GUI ###
		bulky                       # Bulk rename app
		deltachat-desktop           # Email-based instant messaging for Desktop
		discord                     # All-in-one cross-platform voice and text chat for gamers
		# discord-canary              # All-in-one cross-platform voice and text chat for gamers
		hexchat                     # Popular and easy to use graphical IRC (chat) client
		i2p                         # Applications and router for I2P, anonymity over the Internet
		keepassxc                   # Offline password manager with many features
		libreoffice                 # Comprehensive, professional-quality productivity suite, a variant of openoffice.org
		qbittorrent                 # Featureful free software BitTorrent client
		stoat-desktop               # Open source user-first chat platform
		synology-drive-client       # Desktop application to synchronize files and folders between the computer and the Synology Drive server
		zotero                      # Collect, organize, cite, and share your research sources
		evolution                   # Personal information management application that provides integrated mail, calendaring and address book functionality
		# calibre                   # Comprehensive e-book software
		visidata                    # Interactive terminal multitool for tabular data

		];

	### GRAPHICAL SESSION ###
	programs.sway = {
		enable = true;
		wrapperFeatures.gtk = true; # need to set up the gtk portal somewhere else probably
		extraPackages = with pkgs; [
				swaybg              # Wallpaper tool for Wayland compositors
				swaylock            # Screen locker for Wayland
				swayidle            # Idle management daemon for Wayland
				# make sure the default gnome icons are avaliable to gtk applications
				adwaita-icon-theme  # —
			];
	};
	programs.waybar.enable = true;

	### MISC ###

	programs.firefox.enable = true;

# 	programs.firefox = {
# 		enable = true;
# 		languagePacks = [ "en-US" "fr" ];
# 		policies = {
# 			DisableFirefoxStudies           = true;
# 			DisableTelemetry                = true;
# 			DisplayMenuBar                  = "never";
# 			DontCheckDefaultBrowser         = true;
# 		};
# 		preferences = {
# 			# "browser.startup.homepage"    = "https://example.com";
# 			"privacy.resistFingerprinting"  = true;
# 		};
# 	};

	services.gvfs.enable = true;
}
