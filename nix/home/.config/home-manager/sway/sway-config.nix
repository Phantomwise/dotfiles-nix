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
			input = 
				{
				"*" = {
					xkb_layout = "us";
					xkb_variant = "colemak";
					xkb_options = "grp:alt_space_toggle";
				};
			};
		};
		# extraConfig =
		# ''
			# ${builtins.readFile ./oldconfig/config}
			# ${builtins.readFile ./oldconfig/keybindings}
		# '';
	};

}