.PHONY: nix-rebuild-core nix-rebuild nix-rebuild-laptop nix-rebuild-desktop
.PHONY: nix-update-core nix-update nix-update-laptop nix-update-desktop
.PHONY: nix-post

NIXOS_CONFIG ?= /etc/nixos/configuration.nix

nix-rebuild-core:
	@echo -e "\033[1;33mRebuilding system configuration\033[0m"
	sudo nixos-rebuild switch -I nixos-config=$(NIXOS_CONFIG)
	# @echo -e "\033[1;33mRebuilding Home Manager configuration\033[0m"
	# home-manager switch
	# @echo -e "\033[1;32mRebuild complete\033[0m"

nix-update-core:
	@echo -e "\033[1;33mUpdating channels\033[0m"
	nix-channel --update
	sudo nix-channel --update
	@echo -e "\033[1;33mRebuilding updated system configuration\033[0m"
	sudo nixos-rebuild switch --upgrade -I nixos-config=$(NIXOS_CONFIG)
	# @echo -e "\033[1;33mRebuilding updated Home Manager configuration\033[0m"
	# home-manager switch --upgrade
	# @echo -e "\033[1;32mUpdate complete\033[0m"

nix-post:
	# @echo -e "\033[1;33mRefreshing font cache\033[0m"
	fc-cache -fv
	@echo -e "\033[1;32mDiff\033[0m"
	nvd diff $$(ls -d /nix/var/nix/profiles/system-*-link | tail -2)

nix-rebuild:
	$(MAKE) nix-rebuild-core NIXOS_CONFIG=/etc/nixos/configuration.nix
	$(MAKE) nix-post

nix-rebuild-laptop:
	$(MAKE) nix-rebuild-core NIXOS_CONFIG=/etc/nixos/configuration-laptop.nix
	$(MAKE) nix-post

nix-rebuild-desktop:
	$(MAKE) nix-rebuild-core NIXOS_CONFIG=/etc/nixos/configuration-desktop.nix
	$(MAKE) nix-post

nix-update:
	$(MAKE) nix-update-core NIXOS_CONFIG=/etc/nixos/configuration.nix
	$(MAKE) nix-post

nix-update-laptop:
	$(MAKE) nix-update-core NIXOS_CONFIG=/etc/nixos/configuration-laptop.nix
	$(MAKE) nix-post

nix-update-desktop:
	$(MAKE) nix-update-core NIXOS_CONFIG=/etc/nixos/configuration-desktop.nix
	$(MAKE) nix-post
