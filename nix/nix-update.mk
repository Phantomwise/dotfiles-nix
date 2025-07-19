# Declare phony targets
.PHONY: nix-update

# nix-update
nix-update:
	@echo -e "\033[1;33mUpdating channels\033[0m"
	nix-channel --update
	@echo -e "\033[1;33mRebuilding\033[0m"
	sudo nixos-rebuild switch --upgrade
