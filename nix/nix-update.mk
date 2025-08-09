# Declare phony targets
.PHONY: nix-update

# nix-update
nix-update:
	@echo -e "\033[1;33mUpdating channels\033[0m"
	nix-channel --update
	sudo nix-channel --update
	@echo -e "\033[1;33mRebuilding\033[0m"
	sudo nixos-rebuild switch --upgrade
	@echo -e "\033[1;33mRebuilding Home Manager configuration\033[0m"
	home-manager switch
	@echo -e "\033[1;32mUpdate complete\033[0m"
