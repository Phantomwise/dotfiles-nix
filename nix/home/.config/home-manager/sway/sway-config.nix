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
			terminal = "kitty"; 
			# startup = [
				# Launch Firefox on start
				# {command = "firefox";}
			# ];
		};
		extraConfig =
		''
			${builtins.readFile ./oldconfig/config}
			${builtins.readFile ./oldconfig/keybindings}
		'';
	};

}