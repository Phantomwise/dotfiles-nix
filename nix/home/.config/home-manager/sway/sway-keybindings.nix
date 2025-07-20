{ config, pkgs, lib, ... }:

let
# ███████████████████████████████████████████████████████████████╗
# █╔════════════════════════════════════════════════════════════█║
# █║░░░░░░░░░░░░░░░░░░░░░░░░ VARIABLES ░░░░░░░░░░░░░░░░░░░░░░░░░█║
# ███████████████████████████████████████████████████████████████║
# ╚══════════════════════════════════════════════════════════════╝

	mod = config.wayland.windowManager.sway.config.modifier;
	# mod = "mod4";

	# Direction keys
		left  = "n";
		down  = "e";
		up    = "u";
		right = "i";

	# Programs
		term        = "foot";
		terminal    = "kitty";
		texteditor  = "leafpad";
		codeeditor  = "code";
		# codeeditor = "vscodium";
		# codeeditor = "vscodium --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland";
		# codeeditor = "/usr/bin/codium --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland";
		# codeeditor = "code --enable-features=UseOzonePlatform --ozone-platform=wayland";
		filemanager = "nemo";
		office      = "libreoffice";
		webbrowser1 = "firefox";
		webbrowser2 = "librewolf";
		audioplayer = "vlc";
		videoplayer = "vlc";

	# Your preferred application launcher
		# Note: pass the final command to swaymsg so that the resulting window can be opened
		# on the original workspace that the command was run on.
		# set $menu dmenu_path | wmenu | xargs swaymsg exec --

	# Application Launcher
		runmenu         = "rofi -show run";
		drunmenu        = "rofi -show drun";
		sshmenu         = "rofi -show ssh";
		windowmenu      = "rofi -show window";
		filebrowsermenu = "rofi -show filebrowser";
		emoji           = "rofimoji --action copy";
		# emoji         = "rofi -modi 'emoji:rofimoji' -show emoji";
		calc            = "rofi -show calc -no-show-match -no-sort";
			# ERROR: (but still working)
			# ** (process:143427): WARNING **: 16:58:47.111: Mode 'calc' does not have a type set. Please update mode/plugin.
		powermenu       = "rofi -show power-menu -modi power-menu:rofi-power-menu";
			# NB: located in /home/phantomwise/Scripts/rofi-power-menu
			# NB: copy not in use in /home/phantomwise/Scripts/rofi-power-menu
		gamesl          = "rofi -modi games -show games -theme theme-games-phantomwise-large";
		gamess          = "rofi -modi games -show games -theme theme-games-phantomwise-small";

in

{
	wayland.windowManager.sway.config.keybindings = {
		# "${config.wayland.windowManager.sway.config.modifier}+Return" = "exec kitty";
		# "${mod}+Return" = "exec kitty";
		# "${mod}+r" = "exec ${runmenu}";

		# Add your migrated keybindings here...

# ███████████████████████████████████████████████████████████████╗
# █╔════════════════════════════════════════════════════════════█║
# █║░░░░░░░░░░░░░░░░░░░░░░░ KEY BINDINGS ░░░░░░░░░░░░░░░░░░░░░░░█║
# ███████████████████████████████████████████████████████████████║
# ╚══════════════════════════════════════════════════════════════╝

	# Unsorted keybindings
		# Kill focused window
		"${mod}+Shift+q" = "kill";

	# ███████████████████████████████████████████████████████████████╗
	# █╔════════════════════════════════════════════════════════════█║
	# █║░░░░░░░░░░░░░░░░░░░░░░░ APPLICATIONS ░░░░░░░░░░░░░░░░░░░░░░░█║
	# ███████████████████████████████████████████████████████████████║
	# ╚══════════════════════════════════════════════════════════════╝

	# Applications
		"${mod}+Return" = "exec ${term}";
		"${mod}+z" = "exec ${terminal}";
		"Ctrl+Alt+z" = "exec ${terminal}";
		"Ctrl+Alt+t" = "exec ${texteditor}";
		"Ctrl+Alt+c" = "exec ${codeeditor}";
		"Ctrl+Alt+f" = "exec ${filemanager}";
		"Ctrl+Alt+l" = "exec ${webbrowser2}";
		"Ctrl+Alt+o" = "exec ${office}";
		"Ctrl+Alt+w" = "exec ${webbrowser1}";
		"Ctrl+Alt+m" = "exec ${audioplayer}";
		"Ctrl+Alt+v" = "exec ${videoplayer}";

# Start your sway-bar
# bindsym $mod+d exec $menu

	# Start rofi
		"${mod}+r" = "exec ${runmenu}";
		"${mod}+x" = "exec ${drunmenu}";
		"${mod}+d" = "exec ${drunmenu}";
		"${mod}+b" = "exec ${filebrowsermenu}";
		"${mod}+s" = "exec ${sshmenu}";
		"${mod}+m" = "exec ${emoji}";
		"${mod}+c" = "exec ${calc}";
		"${mod}+g" = "exec ${gamess}";
		"${mod}+Shift+g" = "exec ${gamesl}";
		# "${mod}+l" = "exec ${powermenu}";
		"Alt+Tab" = "exec ${windowmenu}";

	# Start/kill waybar
		# "${mod}+Alt+w" = "exec 'pkill waybar || waybar'";
		# "${mod}+Alt+w" = "exec 'killall waybar || waybar --config ~/.config/waybar/config-sway.jsonc'";
		"${mod}+Alt+w" = "exec 'pkill waybar || waybar --config ~/.config/waybar/config-sway.jsonc'";

	# ███████████████████████████████████████████████████████████████╗
	# █╔════════════════════════════════════════════════════════════█║
	# █║░░░░░░░░░░░░░░░░░░░░░░ MOVING AROUND ░░░░░░░░░░░░░░░░░░░░░░░█║
	# ███████████████████████████████████████████████████████████████║
	# ╚══════════════════════════════════════════════════════════════╝

	# Move your focus around
		# "${mod}+${left}" = "focus left";
		# "${mod}+${down}" = "focus down";
		# "${mod}+${up}" = "focus up";
		# "${mod}+${right}" = "focus right";
	# Or use $mod+[up|down|left|right]
		"${mod}+Left" = "focus left";
		"${mod}+Down" = "focus down";
		"${mod}+Up" = "focus up";
		"${mod}+Right" = "focus right";

	# Move the focused window with the same, but add Shift
		# "${mod}+Shift+${left}" = "move left";
		# "${mod}+Shift+${down}" = "move down";
		# "${mod}+Shift+${up}" = "move up";
		# "${mod}+Shift+${right}" = "move right";
	# Ditto, with arrow keys
		"${mod}+Shift+Left" = "move left";
		"${mod}+Shift+Down" = "move down";
		"${mod}+Shift+Up" = "move up";
		"${mod}+Shift+Right" = "move right";

	};
}
