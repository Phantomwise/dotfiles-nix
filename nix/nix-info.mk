# Declare phony targets
.PHONY: nix-info

# nix-info
nix-info:
	@echo -e "\033[1;33mList system channels\033[0m"
	sudo nix-channel --list
	@echo -e "\033[1;33mList user channels\033[0m"
	nix-channel --list
	@echo -e "\033[1;33mList system generations\033[0m"
	sudo nix-env --list-generations
	@echo -e "\033[1;33mList user generations\033[0m"
	nix-env --list-generations
