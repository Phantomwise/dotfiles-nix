{ config, pkgs, ... }:

{
	environment.sessionVariables = rec {
	# environment.sessionVariables = {

		# PATH definitions
		PATH = [ 
			# Add scripts directories
			"$HOME/.local/bin/scripts"
			"$HOME/Scripts"
			# Preserve the existing PATH (optional but recommended)
			"$PATH"
		];

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

		# TEST
		TEST = "test";
	};

}
