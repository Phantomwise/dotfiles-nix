{ config, pkgs, ... }:

{
	environment.sessionVariables = rec {

		# PATH definitions
			# Need to be set at login or session start for every user.
			# Need to apply globally to all shells.
		PATH = [ 
			# Add scripts directories
			"$HOME/.local/bin/scripts"
			"$HOME/Scripts"
			"$PATH" # Doesn't actually preserve the existing PATH because it does't get expanded. Doesn't seem to be doing any harm though I guess that's fine. Leaving it as a reminder to one day getting around to finding a better solution.
		];
		# Alternatives:
			# Shell config: Won't do, needs to work for all shells.
			# Home manager: Won't do, need a solution that works for all users. Also will probably ditch home manager.
			# PAM: Already doing that.
			# Systemd: Probably the better solution but I really really really don't want to deal with systemd T_T

		# Eye candy
		NEWT_COLORS = "root=black,black;window=black,black;border=white,black;listbox=white,black;label=blue,black;checkbox=red,black;title=green,black;button=white,red;actsellistbox=white,red;actlistbox=white,gray;compactbutton=white,gray;actcheckbox=white,blue;entry=lightgray,black;textbox=blue,black";

		# Misc
		EDITOR = "micro";


	# Copy pasted from the wiki because I don't have a clue what I'm doing:

	# This is using a rec (recursive) expression to set and access XDG_BIN_HOME within the expression
	# For more on rec expressions see https://nix.dev/tutorials/first-steps/nix-language#recursive-attribute-set-rec
	# environment.sessionVariables = rec {
		TEST_REC = "test rec";
		XDG_CACHE_HOME  = "$HOME/.cache";
		XDG_CONFIG_HOME = "$HOME/.config";
		XDG_DATA_HOME   = "$HOME/.local/share";
		XDG_STATE_HOME  = "$HOME/.local/state";
		# Not officially in the specification
		# XDG_BIN_HOME    = "$HOME/.local/bin";
		# PATH = [ 
			# "${XDG_BIN_HOME}"
		# ];

		# Wayland
		NIXOS_OZONE_WL = "1";

		# TEST
		TEST = "test";
	};

}
