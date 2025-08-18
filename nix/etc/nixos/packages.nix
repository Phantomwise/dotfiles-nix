{ config, pkgs, ... }:

{

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [

		### UNSORTED ###
		# cron                 # Daemon for running commands at specific times
		jq                     # Lightweight and flexible command-line JSON processor
		inotify-tools          #
		libnotify              # Library that sends desktop notifications to a notification daemon
		tldr                   # Simplified and community-driven man pages
		wine                   # Open Source implementation of the Windows API on top of X, OpenGL, and Unix
		libva-utils            # Collection of utilities and examples for VA-API
 
		### LANGUAGES ###
		(python3.withPackages (ps: [
			ps.requests
			ps.curl-cffi
			]))

		### FILESYSTEMS ###
		gvfs                   # Virtual Filesystem support library
		gnome.gvfs             # Virtual Filesystem support library (full GNOME support)
		nfs-utils              # Linux user-space NFS utilities
		ntfs3g                 # FUSE-based NTFS driver with full write support
		samba                  # Standard Windows interoperability suite of programs for Linux and Unix

		### MONITORING ###
		acpi                   # Show battery status and other ACPI information
		btop                   # Monitor of resources
		intel-gpu-tools        # Tools for development and testing of the Intel DRM driver
		iotop                  # Tool to find out the processes doing the most IO
		lm_sensors             # Tools for reading hardware sensors
		ncdu                   # Disk usage analyzer with an ncurses interface
		smartmontools          # Tools for monitoring the health of hard drives
		sysstat                # Collection of performance monitoring tools for Linux (such as sar, iostat and pidstat)

		### SYSTEM TOOLS ###
		killall                #
		tree                   # Command to produce a depth indented directory listing

		### TOOLS ###
		brightnessctl          # This program allows you read and control device brightness
		# bluetuith            # TUI-based bluetooth connection manager
		git                    # Distributed version control system
		gitmoji-cli            # Gitmoji client for using emojis on commit messages
		gnumake                # Tool to control the generation of non-source files from sources
		rclone                 # Command line program to sync files and directories to and from major cloud storage
		rsync                  # Fast incremental file transfer utility
		steam-run              # Run commands in the same FHS environment that is used for Steam
		stow                   # Tool for managing the installation of multiple software packages in the same run-time directory tree
		tlp                    # Advanced Power Management for Linux

		### CLI ###
		fastfetch              # An actively maintained, feature-rich and performance oriented, neofetch like system information tool
		figlet                 # Program for making large letters out of ordinary text

		### NETWORKING ###
		#  wget                # Tool for retrieving files using HTTP, HTTPS, and FTP
		wg-netmanager          # Wireguard network manager
		wireguard-tools        # Tools for the WireGuard secure network tunnel
		wireguard-ui           # Web user interface to manage your WireGuard setup
		protonvpn-gui          # Proton VPN GTK app for Linux

		### SECURITY ###
		clamav                 # Antivirus engine designed for detecting Trojans, viruses, malware and other malicious threats

		### GRAPHICAL SESSION ###
		dunst                  # Lightweight and customizable notification daemon
		(rofi-wayland.override { plugins = [ pkgs.rofi-calc pkgs.rofi-games ]; })
		rofimoji               # Simple emoji and character picker for rofi
		grim                   # Grab images from a Wayland compositor
		slurp                  # Select a region in a Wayland compositor
		swayimg                # Image viewer for Sway/Wayland #!
		wl-clipboard           # Command-line copy/paste utilities for Wayland
		nemo-with-extensions   # File browser for Cinnamon
		nemo-fileroller        # Nemo file roller extension # TO CHECK IF NEEDED

		### TERMINAL ###
		foot                   # Fast, lightweight and minimalistic Wayland terminal emulator
		kitty                  # The fast, feature-rich, GPU based terminal emulator

		### EDITORS ###
		featherpad             # Lightweight Qt5 Plain-Text Editor for Linux
		kakoune                # Vim inspired text editor #!
		micro-full             # Modern and intuitive terminal-based text editor
		# leafpad # error: 'leafpad' has been removed due to lack of maintenance upstream. Consider using 'xfce.mousepad' instead
		# ms-edit # not in repo
		vim                    # Most popular clone of the VI editor

		### IMAGE ###
		gimp3-with-plugins     # GNU Image Manipulation Program
		imagemagick            # Software suite to create, edit, compose, or convert bitmap images
		ksnip                  # Cross-platform screenshot tool with many annotation features
		sway-contrib.grimshot  # Helper for screenshots within sway
		tiled                  # Free, easy to use and flexible tile map editor
		xnviewmp               # Efficient multimedia viewer, browser and converter

		### AUDIO & VIDEO ###
		abcde                  # Command-line audio CD ripper
		ani-cli                # Cli tool to browse and play anime
		asunder                # Graphical Audio CD ripper and encoder for Linux
		cdrkit                 # Portable command-line CD/DVD recorder software, mostly compatible with cdrtools
		ffmpeg                 # Complete, cross-platform solution to record, convert and stream audio and video
		# libation # moved to unstable
		mpc                    #!
		picard                 # picard
		pulsemixer             # Cli and curses mixer for pulseaudio
		vlc                    # Cross-platform media player and streaming server
		(callPackage (import (builtins.fetchurl {
  url = "https://raw.githubusercontent.com/NixOS/nixpkgs/da2504032ba518133db8f559862d95bc95b1f81c/pkgs/by-name/yt/yt-dlp/package.nix";
  sha256 = "sha256:1ffrks7nk9s30g70k6b5qfyiy9ad8ydsqkq3y69f35pfxqblwfb7";
})) {})

		### MISC GUI ###
		bulky                  # Bulk rename app
		deltachat-desktop      # Email-based instant messaging for Desktop
		discord                # All-in-one cross-platform voice and text chat for gamers
		discord-canary         # All-in-one cross-platform voice and text chat for gamers
		freetube               # Open Source YouTube app for privacy
		keepassxc              # Offline password manager with many features
		libreoffice            # Comprehensive, professional-quality productivity suite, a variant of openoffice.org
		synology-drive-client  # Desktop application to synchronize files and folders between the computer and the Synology Drive server
		zotero                 # Collect, organize, cite, and share your research sources
		evolution              # Personal information management application that provides integrated mail, calendaring and address book functionality

			(vscode-with-extensions.override {
				vscodeExtensions = with vscode-extensions; [
					bodil.blueprint-gtk          # Gtk Blueprint language support.
					ms-vscode.makefile-tools     # — Makefile language support
					bbenoist.nix                 # — Nix language support
					tamasfe.even-better-toml     # — TOML language support
					ms-python.python             # Visual Studio Code extension with rich support for the Python language
					naumovs.color-highlight      # Highlight web colors in your editor
					ms-azuretools.vscode-docker  # Docker Extension for Visual Studio Code
					donjayamanne.githistory      # View git log, file history, compare branches or commits
					seatonjiang.gitmoji-vscode   # Gitmoji tool for git commit messages in VSCode
					github.copilot               # GitHub Copilot uses OpenAI Codex to suggest code and entire functions in real-time right from your editor
					ms-vscode-remote.remote-ssh  # Use any remote machine with a SSH server as your development environment
				] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
					{
						name = "remote-ssh-edit";
						publisher = "ms-vscode-remote";
						version = "0.47.2";
						sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
					}
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
