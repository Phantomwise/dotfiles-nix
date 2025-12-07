{ config, pkgs, ... }:

# let
	# swayKeybindings = import ./sway-keybindings.nix { inherit config pkgs lib; };
# in

{

	imports =
	[
		./sway-keybindings.nix
	];

	wayland.windowManager.sway = {
		enable = true;
		config = rec {
			modifier = "Mod4";
			left = "n";
				# Mod1 = Alt
				# Mod4 = Win
			terminal = "kitty"; 
			# startup = [
				# Launch Firefox on start
				# {command = "firefox";}
			# ];
			input = {
				"*" = {
					xkb_layout = "us";
					xkb_variant = "colemak";
					xkb_options = "grp:alt_space_toggle";
				};
			};

			bars = [];

			colors = {
				# class names (camelCase) the module expects:
				focused = {
					border     = "#004BAA";  # previously title_border_color
					background = "#000000";  # previously title_background_color
					text       = "#ffffff";  # previously title_text_color
					indicator  = "#ffffff";  # previously indicator_color
					childBorder = "#004BAA"; # previously child_border_color
				};
				focusedInactive = {
					border     = "#000000";  # previously title_border_color
					background = "#000000";  # previously title_background_color
					text       = "#ffffff";  # previously title_text_color
					indicator  = "#ffffff";  # previously indicator_color
					childBorder = "#000000"; # previously child_border_color
				};
				unfocused = {
					border     = "#000000";  # previously title_border_color
					background = "#000000";  # previously title_background_color
					text       = "#ffffff";  # previously title_text_color
					indicator  = "#ffffff";  # previously indicator_color
					childBorder = "#000000"; # previously child_border_color
				};
				urgent = {
					border     = "#A10000";  # previously title_border_color
					background = "#A10000";  # previously title_background_color
					text       = "#ffffff";  # previously title_text_color
					indicator  = "#A10000";  # previously indicator_color
					childBorder = "#004BAA"; # previously child_border_color
				};
	# client.<class> <border> <background> <text> [<indicator> [<child_border>]]
		# Configures  the  color  of window borders and title bars. The first three colors are required.
		# When omitted indicator will use a sane default and child_border will use  the  color  set  for
		# background. Colors may be specified in hex, either as #RRGGBB or #RRGGBBAA.
		#
		# The available classes are:
			# client.focused
				# The window that has focus.
			# client.focused_inactive
				# The most recently focused view within a container which is not focused.
			# client.focused_tab_title
				# A  view  that  has  focused descendant container. Tab or stack container title that is the
				# parent of the focused container but is not directly focused. Defaults to  focused_inactive
				# if not specified and does not use the indicator and child_border colors.
			# client.placeholder
				# Ignored (present for i3 compatibility).
			# client.unfocused
				# A view that does not have focus.
			# client.urgent
				# A  view with an urgency hint. Note: Native Wayland windows do not support urgency. Urgency
				# only works for Xwayland windows.
		#
		# The meaning of each color is:
			# border
				# The border around the title bar.
			# background
				# The background of the title bar.
			# text
				# The text color of the title bar.
			# indicator
				# The color used to indicate where a new view will open. In a tiled  container,  this  would
				# paint the right border of the current view if a new view would be opened to the right.
			# child_border
				# The border around the view itself.
			};

			fonts = {
				names = [ "Dungeon Regular" ];
				# style = "Bold Semi-Condensed";
				size = 11.0;
			};

			gaps = {
				# Sets  default  amount pixels of inner or outer gap, where the inner affects spacing around each view and outer affects the spacing around each
				# workspace. Outer gaps are in addition to inner gaps. To reduce or remove outer gaps, outer gaps can be set to a negative value. outer gaps can
				# also be specified per side with top, right, bottom, and left or per direction with horizontal and vertical.
				# This affects new workspaces only, and is used when the workspace doesn't have its own gaps settings (see: workspace <ws> gaps ...).
				inner = 6;
				outer = -6;
				# top = 8;
				bottom = 6;
				# left = 8;
				# right = 8;
				# horizontal = 8;
				# vertical = 8;
			};

			startup = [
				{
					# NOTWORKING >_<
					command = ''
						${pkgs.waybar}/bin/waybar --config ~/.config/waybar/config-sway.jsonc
						'';
						# ${pkgs.bash}/bin/bash -lc 'pkill -x waybar 2>/dev/null || true; exec ${pkgs.waybar}/bin/waybar --config "$HOME/.config/waybar/config-sway.jsonc"'
						# ${pkgs.bash}/bin/bash -lc 'pgrep -x waybar >/dev/null || exec ${pkgs.waybar}/bin/waybar --config "$HOME/.config/waybar/config-sway.jsonc"'
					# always = true;
					# ${pkgs.bash}/bin/bash -lc 'pkill -x waybar || true; exec ${pkgs.waybar}/bin/waybar --config $HOME/.config/waybar/config-sway.jsonc'
					# always = true;
					# command = "${pkgs.waybar}/bin/waybar --config ~/.config/waybar/config-sway.jsonc";
				}
			];

			window = {
				titlebar = false;
				border = 2;
			};

		};
		extraConfig =
			''
			exec 'swaybg'
			output * bg /home/phantomwise/.local/share/wallpapers/default.jpg fill '#123456'
			''
		;
		# extraConfig =
			# ''
			# exec 'pkill waybar || waybar --config ~/.config/waybar/config-sway.jsonc'
			# ''
		# ;
		# extraConfig =
		# ''
			# ${builtins.readFile ./oldconfig/config}
			# ${builtins.readFile ./oldconfig/keybindings}
		# '';
		# };
	};

}