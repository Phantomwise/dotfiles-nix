# Declare phony targets
.PHONY: nix-update nix-update-laptop nix-update-desktop

NIXOS_CONFIG ?= /etc/nixos/configuration.nix

nix-update:
	@echo -e "\033[1;33mUpdating channels\033[0m"
	nix-channel --update
	sudo nix-channel --update
	@echo -e "\033[1;33mRebuilding\033[0m"
	sudo nixos-rebuild switch --upgrade -I nixos-config=$(NIXOS_CONFIG)
	# @echo -e "\033[1;33mRebuilding Home Manager configuration\033[0m"
	# home-manager switch
	# @echo -e "\033[1;32mUpdate complete\033[0m"
	nvd diff $$(ls -d /nix/var/nix/profiles/system-*-link | tail -2)

nix-update-laptop:
	$(MAKE) nix-update NIXOS_CONFIG=/etc/nixos/configuration-laptop.nix

nix-update-desktop:
	$(MAKE) nix-update NIXOS_CONFIG=/etc/nixos/configuration-desktop.nix
