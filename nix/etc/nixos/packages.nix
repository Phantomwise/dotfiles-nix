{ config, pkgs, ... }:

{

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	nixpkgs.config.permittedInsecurePackages = [
		"ventoy-1.1.07"
		"mbedtls-2.28.10"
	];

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [

		### UNSORTED ###
		appimage-run                # 
		# cron                      # Daemon for running commands at specific times
		dig                         # Domain name server
		inotify-tools               #
		tldr                        # Simplified and community-driven man pages
		ventoy-full                 # New Bootable USB Solution
		wine                        # Open Source implementation of the Windows API on top of X, OpenGL, and Unix
		libgourou                   # Implementation of Adobe's ADEPT protocol for ePub/PDF DRM

		### PROGRAMMING ###
		git                         # Distributed version control system
		git-filter-repo             # Quickly rewrite git repository history
		gitmoji-cli                 # Gitmoji client for using emojis on commit messages
			### ASSEMBLY ###
		cutter                      # Free and Open Source Reverse Engineering Platform powered by rizin
		# ida-free                  # Freeware version of the world's smartest and most feature-full disassembler
		                            # NB: Can't be downloaded automatically because of licensing
		nasm                        # 80x86 and x86-64 assembler designed for portability and modularity
			### C ###
		clang                       # C language family frontend for LLVM (wrapper script)
		gcc                         # GNU Compiler Collection, version 14.3.0 (wrapper script)
		codeblocksFull              # Open source, cross platform, free C, C++ and Fortran IDE
		clang-tools                 # Standalone command line tools for C++ development
			### JAVASCRIPT ###
		deno                        # Secure runtime for JavaScript and TypeScript
			### JSON ###
		jq                          # Lightweight and flexible command-line JSON processor
			### OCAML ###
		ocaml                       # OCaml is an industrial-strength programming language supporting functional, imperative and object-oriented styles
		ocamlPackages.ocaml-lsp     # OCaml Language Server Protocol implementation
		ocamlPackages.utop          # Universal toplevel for OCaml
		ocamlPackages.ocamlformat   # Auto-formatter for OCaml code
			### PYTHON ###
		(python3.withPackages (ps: [
			ps.requests
			ps.curl-cffi
			ps.colorama             # Cross-platform colored terminal text
			ps.pandas               # Powerful data structures for data analysis, time series, and statistics
			]))
			### SQL ###
		# sqlite                    # Self-contained, serverless, zero-configuration, transactional SQL database engine
		sqlite-interactive          # Self-contained, serverless, zero-configuration, transactional SQL database engine
		sqlitebrowser               # DB Browser for SQLite

		### LIBRARIES ###
		libnotify                   # Library that sends desktop notifications to a notification daemon
		libva-utils                 # Collection of utilities and examples for VA-API
		libGLU                      # OpenGL utility library
		mesa                        # Open source 3D graphics library

		### FILESYSTEMS ###
		cifs-utils                  # Tools for managing Linux CIFS client filesystems
		gvfs                        # Virtual Filesystem support library
		gnome.gvfs                  # Virtual Filesystem support library (full GNOME support)
		nfs-utils                   # Linux user-space NFS utilities
		ntfs3g                      # FUSE-based NTFS driver with full write support
		samba                       # Standard Windows interoperability suite of programs for Linux and Unix

		### MONITORING ###
		acpi                        # Show battery status and other ACPI information
		btop                        # Monitor of resources
		intel-gpu-tools             # Tools for development and testing of the Intel DRM driver
		iotop                       # Tool to find out the processes doing the most IO
		lm_sensors                  # Tools for reading hardware sensors
		ncdu                        # Disk usage analyzer with an ncurses interface
		nethogs                     # Small 'net top' tool, grouping bandwidth by process
		smartmontools               # Tools for monitoring the health of hard drives
		sysstat                     # Collection of performance monitoring tools for Linux (such as sar, iostat and pidstat)

		### SYSTEM TOOLS ###
		killall                     #
		tree                        # Command to produce a depth indented directory listing

		### TOOLS ###
		brightnessctl               # This program allows you read and control device brightness
		# bluetuith                 # TUI-based bluetooth connection manager
		gnumake                     # Tool to control the generation of non-source files from sources
		rclone                      # Command line program to sync files and directories to and from major cloud storage
		rsync                       # Fast incremental file transfer utility
		steam-run                   # Run commands in the same FHS environment that is used for Steam
		stow                        # Tool for managing the installation of multiple software packages in the same run-time directory tree
		tlp                         # Advanced Power Management for Linux

		### CLI ###
		fastfetch                   # An actively maintained, feature-rich and performance oriented, neofetch like system information tool
		figlet                      # Program for making large letters out of ordinary text

		### NETWORKING ###
		#  wget                     # Tool for retrieving files using HTTP, HTTPS, and FTP
		wg-netmanager               # Wireguard network manager
		wireguard-tools             # Tools for the WireGuard secure network tunnel
		wireguard-ui                # Web user interface to manage your WireGuard setup
		protonvpn-gui               # Proton VPN GTK app for Linux

		### SECURITY ###
		clamav                      # Antivirus engine designed for detecting Trojans, viruses, malware and other malicious threats

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
		micro-full                  # Modern and intuitive terminal-based text editor
		# leafpad                   # error: 'leafpad' has been removed due to lack of maintenance upstream. Consider using 'xfce.mousepad' instead
		# ms-edit                   # not in repo
		vim                         # Most popular clone of the VI editor

		### IMAGE ###
		gimp3-with-plugins          # GNU Image Manipulation Program
		imagemagick                 # Software suite to create, edit, compose, or convert bitmap images
		ksnip                       # Cross-platform screenshot tool with many annotation features
		sway-contrib.grimshot       # Helper for screenshots within sway
		tiled                       # Free, easy to use and flexible tile map editor
		xnviewmp                    # Efficient multimedia viewer, browser and converter

		### AUDIO & VIDEO ###
		ani-cli                     # Cli tool to browse and play anime
		beets                       # Music tagger and library organizer
		ffmpeg                      # Complete, cross-platform solution to record, convert and stream audio and video
		finamp                      # Open source Jellyfin music player
		# jellyfin-media-player       # Jellyfin Desktop Client based on Plex Media Player
		mpv                         # General-purpose media player, fork of MPlayer and mplayer2
		# libation # moved to unstable
		mpc                         #!
		picard                      # picard
		pulsemixer                  # Cli and curses mixer for pulseaudio
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
		exactaudiocopy              # Precise CD audio grabber for creating perfect quality rips using CD and DVD drives
		handbrake                   # Tool for converting video files and ripping DVDs
		libdvdcss                   # Library for decrypting DVDs
		makemkv                     # Convert blu-ray and dvd to mkv
		rubyripper                  # High quality CD audio ripper
		whipper                     # CD ripper aiming for accuracy over speed

		### MISC GUI ###
		bulky                       # Bulk rename app
		deltachat-desktop           # Email-based instant messaging for Desktop
		discord                     # All-in-one cross-platform voice and text chat for gamers
		discord-canary              # All-in-one cross-platform voice and text chat for gamers
		freetube                    # Open Source YouTube app for privacy
		keepassxc                   # Offline password manager with many features
		libreoffice                 # Comprehensive, professional-quality productivity suite, a variant of openoffice.org
		qbittorrent                 # Featureful free software BitTorrent client
		synology-drive-client       # Desktop application to synchronize files and folders between the computer and the Synology Drive server
		zotero                      # Collect, organize, cite, and share your research sources
		evolution                   # Personal information management application that provides integrated mail, calendaring and address book functionality
		# calibre                   # Comprehensive e-book software

			(vscode-with-extensions.override {
				vscodeExtensions = with vscode-extensions; [
					### LANGUAGES ###
					bbenoist.nix                              # — Nix language support
					bodil.blueprint-gtk                       # Gtk Blueprint language support.
					golang.go                                 # Go extension for Visual Studio Code
					ms-python.python                          # Visual Studio Code extension with rich support for the Python language
					ms-vscode.cpptools                        # C/C++ extension adds language support for C/C++ to Visual Studio Code, including features such as IntelliSense and debugging
					ms-vscode.makefile-tools                  # — Makefile language support
					ms-python.vscode-pylance                  # Performant, feature-rich language server for Python in VS Code
					mechatroner.rainbow-csv                   # Rainbow syntax higlighting for CSV and TSV files in Visual Studio Code
					thenuprojectcontributors.vscode-nushell-lang  #
					ocamllabs.ocaml-platform                  # Official OCaml Support from OCamlLabs
					tamasfe.even-better-toml                  # — TOML language support
					theangryepicbanana.language-pascal        # VSCode extension for high-quality Pascal highlighting
					### OTHER ###
					naumovs.color-highlight                   # Highlight web colors in your editor
					ms-azuretools.vscode-docker               # Docker Extension for Visual Studio Code
					donjayamanne.githistory                   # View git log, file history, compare branches or commits
					seatonjiang.gitmoji-vscode                # Gitmoji tool for git commit messages in VSCode
					ms-vscode-remote.remote-ssh               # Use any remote machine with a SSH server as your development environment
					github.copilot                            # GitHub Copilot uses OpenAI Codex to suggest code and entire functions in real-time right from your editor
					### COLOR THEMES ###
					carrie999.cyberpunk-2020                  # Cyberpunk-inspired colour theme to satisfy your neon dreams
					dhedgecock.radical-vscode                 # Dark theme for radical hacking inspired by retro futuristic design
					nonylene.dark-molokai-theme               # Theme inspired by VSCode default dark theme, monokai theme and Vim Molokai theme
					nur.just-black                            # Dark theme designed specifically for syntax highlighting
					viktorqvarfordt.vscode-pitch-black-theme  # 
					zhuangtongfa.material-theme               # 
					### ICON THEMES ###
					teabyii.ayu                               # Simple theme with bright colors and comes in three versions — dark, light and mirage for all day long comfortable work
					vscode-icons-team.vscode-icons            # Bring real icons to your Visual Studio Code
					# pkief.material-icon-theme               # Material Design Icons for Visual Studio Code
				];
			})
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
	services.gvfs.enable = true;
}
