# ███████████████████████████████████████████████████████████████╗
# █╔════════════════════════════════════════════════════════════█║
# █║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█║
# █║░░░░░░░░░░░░░███████╗██╗░░░░██╗░█████╗░██╗░░░██╗░░░░░░░░░░░░█║
# █║░░░░░░░░░░░░░██╔════╝██║░░░░██║██╔══██╗╚██╗░██╔╝░░░░░░░░░░░░█║
# █║░░░░░░░░░░░░░███████╗██║░█╗░██║███████║░╚████╔╝░░░░░░░░░░░░░█║
# █║░░░░░░░░░░░░░╚════██║██║███╗██║██╔══██║░░╚██╔╝░░░░░░░░░░░░░░█║
# █║░░░░░░░░░░░░░███████║╚███╔███╔╝██║░░██║░░░██║░░░░░░░░░░░░░░░█║
# █║░░░░░░░░░░░░░╚══════╝░╚══╝╚══╝░╚═╝░░╚═╝░░░╚═╝░░░░░░░░░░░░░░░█║
# █║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█║
# █║░░░░░░░░░░░░░░░░░░░░░░░ Home Manager ░░░░░░░░░░░░░░░░░░░░░░░█║
# █║░░░░░░░░░░░░░░░░░░░░ Sway configuration ░░░░░░░░░░░░░░░░░░░░█║
# █║░░░░░░░░░░░░░░░░░░░░░░░ Keybindings ░░░░░░░░░░░░░░░░░░░░░░░░█║
# █║░░░░░░░░░░░░░░░░░░░░░░ by Phantomwise ░░░░░░░░░░░░░░░░░░░░░░█║
# █║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█║
# ███████████████████████████████████████████████████████████████║
# ╚══════════════════════════════════════════════════════════════╝

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

		# Mouse bindings
			# Mouse bindings operate on the container under the cursor instead of the container that has fo‐
			# cus. Mouse buttons can either be specified in the form button[1-9] or by using the name of the
			# event code (ex BTN_LEFT or BTN_RIGHT). For the former option, the buttons will  be  mapped  to
			# their  values  in  X11  (1=left, 2=middle, 3=right, 4=scroll up, 5=scroll down, 6=scroll left,
			# 7=scroll right, 8=back, 9=forward). For the latter option, you can find the event names  using
			# libinput debug-events.

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
# "${mod}+d" = "exec $menu";

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

	# ███████████████████████████████████████████████████████████████╗
	# █╔════════════════════════════════════════════════════════════█║
	# █║░░░░░░░░░░░░░░░░░░░░░░░░ WORKSPACES ░░░░░░░░░░░░░░░░░░░░░░░░█║
	# ███████████████████████████████████████████████████████████████║
	# ╚══════════════════════════════════════════════════════════════╝

		# Switch to workspace
			"${mod}+1" = "workspace number 1";
			"${mod}+2" = "workspace number 2";
			"${mod}+3" = "workspace number 3";
			"${mod}+4" = "workspace number 4";
			"${mod}+5" = "workspace number 5";
			"${mod}+6" = "workspace number 6";
			"${mod}+7" = "workspace number 7";
			"${mod}+8" = "workspace number 8";
			"${mod}+9" = "workspace number 9";
			"${mod}+0" = "workspace number 10";

		# Cycle through workspaces
			"${mod}+Tab" = "workspace next";
			"${mod}+Prior" = "workspace prev";
			"${mod}+Next" = "workspace next";

		# Cycle through workspaces with the mouse
			# "${mod}+button4" = "workspace prev";
			# "${mod}+button5" = "workspace next";
		# NOTWORKING
		# Original config:
			# Cycle through workspaces with the mouse
			# bindsym --whole-window {
				# $mod+button4 workspace prev
				# $mod+button5 workspace next
			# }

		# Move focused container to workspace
			"${mod}+Shift+1" = "move container to workspace number 1";
			"${mod}+Shift+2" = "move container to workspace number 2";
			"${mod}+Shift+3" = "move container to workspace number 3";
			"${mod}+Shift+4" = "move container to workspace number 4";
			"${mod}+Shift+5" = "move container to workspace number 5";
			"${mod}+Shift+6" = "move container to workspace number 6";
			"${mod}+Shift+7" = "move container to workspace number 7";
			"${mod}+Shift+8" = "move container to workspace number 8";
			"${mod}+Shift+9" = "move container to workspace number 9";
			"${mod}+Shift+0" = "move container to workspace number 10";
		# Note: workspaces can have any name you want, not just numbers.
		# We just use 1-10 as the default.

	# ███████████████████████████████████████████████████████████████╗
	# █╔════════════════════════════════════════════════════════════█║
	# █║░░░░░░░░░░░░░░░░░░░░░░░░░░ LAYOUT ░░░░░░░░░░░░░░░░░░░░░░░░░░█║
	# ███████████████████████████████████████████████████████████████║
	# ╚══════════════════════════════════════════════════════════════╝

		# You can "split" the current object of your focus with
		# $mod+b or $mod+v, for horizontal and vertical splits
		# respectively.
			"${mod}+h" = "splith";
			"${mod}+v" = "splitv";

		# layout default|splith|splitv|stacking|tabbed
			# Sets the layout mode of the focused container.

		# Switch the current container between different layout styles
		# "${mod}+d layout default
			"${mod}+alt+s" = "layout stacking";
			"${mod}+alt+t" = "layout tabbed";
			"${mod}+alt+e" = "layout toggle split";
			"${mod}+alt+h" = "layout splith";
			"${mod}+alt+v" = "layout splitv";

		# layout toggle [split|all]
			# Cycles  the  layout mode of the focused container though a preset list of layouts. If no argu‐
			# ment is given, then it cycles through stacking, tabbed and the last split layout. If split  is
			# given, then it cycles through splith and splitv. If all is given, then it cycles through every
			# layout.
			"${mod}+l" = "layout toggle all";
			# "${mod}+p" = "layout toggle split";

		# Cycles the layout mode of the focused container through a list of layouts.
			# layout toggle [split|tabbed|stacking|splitv|splith] [split|tabbed|stacking|splitv|splith]...

		# Make the current focus fullscreen
		"${mod}+f" = "fullscreen";

		# Toggle the current focus between tiling and floating mode
		"${mod}+Shift+space" = "floating toggle";

		# Swap focus between the tiling area and the floating area
		"${mod}+space" = "focus mode_toggle";

		# Move focus to the parent container
		"${mod}+a" = "focus parent";

	# ███████████████████████████████████████████████████████████████╗
	# █╔════════════════════════════════════════════════════════════█║
	# █║░░░░░░░░░░░░░░░░░░░░░░░░ SCRATCHPAD ░░░░░░░░░░░░░░░░░░░░░░░░█║
	# ███████████████████████████████████████████████████████████████║
	# ╚══════════════════════════════════════════════════════════════╝

		# Sway has a "scratchpad", which is a bag of holding for windows.
		# You can send windows there and get them back later.

		# Move the currently focused window to the scratchpad
		"${mod}+Shift+minus" = "move scratchpad";

		# Show the next scratchpad window or hide the focused scratchpad window.
		# If there are multiple scratchpad windows, this command cycles through them.
		"${mod}+minus" = "scratchpad show";

	# ███████████████████████████████████████████████████████████████╗
	# █╔════════════════════════════════════════════════════════════█║
	# █║░░░░░░░░░░░░░░░░░░░░░░░░░░ RESIZE ░░░░░░░░░░░░░░░░░░░░░░░░░░█║
	# ███████████████████████████████████████████████████████████████║
	# ╚══════════════════════════════════════════════════════════════╝

		"${mod}+Shift+r" = "mode 'resize'";

	# ███████████████████████████████████████████████████████████████╗
	# █╔════════════════════════════════════════════════════════════█║
	# █║░░░░░░░░░░░░░░░░░░░░░░░░░░ VOLUME ░░░░░░░░░░░░░░░░░░░░░░░░░░█║
	# ███████████████████████████████████████████████████████████████║
	# ╚══════════════════════════════════════════════════════════════╝

		# Change volume with volume keys
			"XF86AudioRaiseVolume"       = "exec bash -c 'wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 2%+; bash $HOME/.local/bin/scripts/dunst/volume-change.sh'";
			"XF86AudioLowerVolume"       = "exec bash -c 'wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 2%-; bash $HOME/.local/bin/scripts/dunst/volume-change.sh'";
			"Shift+XF86AudioRaiseVolume" = "exec bash -c 'wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 100%; bash $HOME/.local/bin/scripts/dunst/volume-change.sh'";
			"Shift+XF86AudioLowerVolume" = "exec bash -c 'wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 0%; bash $HOME/.local/bin/scripts/dunst/volume-change.sh'";
			"XF86AudioMute"              = "exec bash -c 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle; bash $HOME/.local/bin/scripts/dunst/volume-mute.sh'";

		# Change volume with mod + F1/F2/F3 keys
			"${mod}+F3"                  = "exec bash -c 'wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 2%+; bash $HOME/.local/bin/scripts/dunst/volume-change.sh'";
			"${mod}+F2"                  = "exec bash -c 'wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 2%-; bash $HOME/.local/bin/scripts/dunst/volume-change.sh'";
			"${mod}+Shift+F3"            = "exec bash -c 'wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 100%; bash $HOME/.local/bin/scripts/dunst/volume-change.sh'";
			"${mod}+Shift+F2"            = "exec bash -c 'wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 0%; bash $HOME/.local/bin/scripts/dunst/volume-change.sh'";
			"${mod}+F1"                  = "exec bash -c 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle; bash $HOME/.local/bin/scripts/dunst/volume-mute.sh'";

	# ███████████████████████████████████████████████████████████████╗
	# █╔════════════════════════════════════════════════════════════█║
	# █║░░░░░░░░░░░░░░░░░░░░ SCREEN BRIGHTNESS ░░░░░░░░░░░░░░░░░░░░░█║
	# ███████████████████████████████████████████████████████████████║
	# ╚══════════════════════════════════════════════════════════════╝

		# Change brightness with brightness keys
			"XF86MonBrightnessUp"         = "exec brightnessctl set 5%+ && exec $HOME/.local/bin/scripts/dunst/brightness.sh";
			"XF86MonBrightnessDown"       = "exec brightnessctl set 5%- && exec $HOME/.local/bin/scripts/dunst/brightness.sh";
			"Shift+XF86MonBrightnessUp"   = "exec brightnessctl set 100% && exec $HOME/.local/bin/scripts/dunst/brightness.sh";
			"Shift+XF86MonBrightnessDown" = "exec brightnessctl set 0% && exec $HOME/.local/bin/scripts/dunst/brightness.sh";

		# Change brightness with ctrl + volume keys
			"Ctrl+XF86AudioRaiseVolume"   = "exec brightnessctl set 5%+ && exec $HOME/.local/bin/scripts/dunst/brightness.sh";
			"Ctrl+XF86AudioLowerVolume"   = "exec brightnessctl set 5%- && exec $HOME/.local/bin/scripts/dunst/brightness.sh";
			"Ctrl+XF86AudioMute"          = "exec brightnessctl set 50% && exec $HOME/.local/bin/scripts/dunst/brightness.sh";

		# Change brightness with mod + F10/F11
			"${mod}+F11"                  = "exec brightnessctl set 5%+ && exec $HOME/.local/bin/scripts/dunst/brightness.sh";
			"${mod}+F10"                  = "exec brightnessctl set 5%- && exec $HOME/.local/bin/scripts/dunst/brightness.sh";

	# ███████████████████████████████████████████████████████████████╗
	# █╔════════════════════════════════════════════════════════════█║
	# █║░░░░░░░░░░░░░░░░░░░░░░░ SCREENSHOTS ░░░░░░░░░░░░░░░░░░░░░░░░█║
	# ███████████████████████████████████████████████████████████████║
	# ╚══════════════════════════════════════════════════════════════╝

	# ███████████████████████████████████████████████████████████████╗
	# █╔════════════════════════════════════════════════════════════█║
	# █║░░░░░░░░░░░░░░░░░░░░░░░░ WALLPAPER ░░░░░░░░░░░░░░░░░░░░░░░░░█║
	# █║░░░░░░░░░░░░░░░░░░░░░░░░░░ SWAYBG ░░░░░░░░░░░░░░░░░░░░░░░░░░█║
	# ███████████████████████████████████████████████████████████████║
	# ╚══════════════════════════════════════════════════════════════╝

	};

# ███████████████████████████████████████████████████████████████╗
# █╔════════════════════════════════════════════════════════════█║
# █║░░░░░░░░░░░░░░░░░░░░░░░░░░ MODES ░░░░░░░░░░░░░░░░░░░░░░░░░░░█║
# ███████████████████████████████████████████████████████████████║
# ╚══════════════════════════════════════════════════════════════╝

	wayland.windowManager.sway.config.modes =
	{

	# ███████████████████████████████████████████████████████████████╗
	# █╔════════════════════════════════════════════════════════════█║
	# █║░░░░░░░░░░░░░░░░░░░░░░░░░░ RESIZE ░░░░░░░░░░░░░░░░░░░░░░░░░░█║
	# ███████████████████████████████████████████████████████████████║
	# ╚══════════════════════════════════════════════════════════════╝

		resize =
		{
			# Resize with letter keys
				# bindsym $left resize shrink width 10px
				# bindsym $down resize grow height 10px
				# bindsym $up resize shrink height 10px
				# bindsym $right resize grow width 10px

			# Resize with arrow keys
				"Left" = "resize shrink width 10px";
				"Down" = "resize grow height 10px";
				"Up" = "resize shrink height 10px";
				"Right" = "resize grow width 10px";

			# Return to default mode
				"Return" = "mode 'default'";
				"Escape" = "mode 'default'";
		};
	};

}

# ███████████████████████████████████████████████████████████████╗
# █╔════════════════════════════════════════════════════════════█║
# █║░░░░░░░░░░░░░░░░░░░░░░░░░░░ END ░░░░░░░░░░░░░░░░░░░░░░░░░░░░█║
# ███████████████████████████████████████████████████████████████║
# ╚══════════════════════════════════════════════════════════════╝
