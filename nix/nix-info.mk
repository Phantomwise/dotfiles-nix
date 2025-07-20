# Declare phony targets
.PHONY: nix-info

# nix-info
nix-info:

	nix-channel --list
	sudo nix-channel --list
