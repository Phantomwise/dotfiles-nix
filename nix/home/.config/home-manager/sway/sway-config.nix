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
# # class                  title_border_color title_background_color title_text_color indicator_color child_border_color
# client.focused           $rgba-blue         $rgba-black            $rgba-white      $rgba-white     $rgba-blue
# client.focused_inactive  $rgba-black        $rgba-black            $rgba-white      $rgba-white     $rgba-black
# client.focused_tab_title $rgba-black        $rgba-black            $rgba-white      $rgba-white     $rgba-black
# client.unfocused         $rgba-black        $rgba-black            $rgba-white      $rgba-white     $rgba-black
# client.urgent            $rgba-red          $rgba-red              $rgba-white      $rgba-red       $rgba-blue
			};

			fonts = {
				names = [ "Dungeon Regular" ];
				# style = "Bold Semi-Condensed";
				size = 11.0;
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
			};

		};
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