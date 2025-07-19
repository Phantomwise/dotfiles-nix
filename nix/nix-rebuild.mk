# Declare phony targets
.PHONY: nix-rebuild

# nix-rebuild
nix-rebuild:
	@echo -e "\033[1;33mRebuilding\033[0m"
	sudo nixos-rebuild switch