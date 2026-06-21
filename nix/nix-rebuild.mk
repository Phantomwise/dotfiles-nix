# Declare phony targets
.PHONY: nix-rebuild nix-rebuild-laptop nix-rebuild-desktop

NIXOS_CONFIG ?= /etc/nixos/configuration.nix

nix-rebuild:
	@echo -e "\033[1;33mRebuilding system configuration\033[0m"
	sudo nixos-rebuild switch -I nixos-config=$(NIXOS_CONFIG)
	@echo -e "\033[1;33mRebuilding Home Manager configuration\033[0m"
	# home-manager switch
	# @echo -e "\033[1;33mRefreshing font cache\033[0m"
	fc-cache -fv
	@echo -e "\033[1;32mRebuild complete\033[0m"
	nvd diff $$(ls -d /nix/var/nix/profiles/system-*-link | tail -2)

nix-rebuild-laptop:
	$(MAKE) nix-rebuild NIXOS_CONFIG=/etc/nixos/configuration-laptop.nix

nix-rebuild-desktop:
	$(MAKE) nix-rebuild NIXOS_CONFIG=/etc/nixos/configuration-desktop.nix
