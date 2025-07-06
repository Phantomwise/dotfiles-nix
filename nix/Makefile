# Declare phony targets
.PHONY: restow nix-cleanup nix-update

# Declare directories
CONFIG_DIR := /home/phantomwise/SynologyDrive/dotfiles-nix/nix
PERSONAL_DIR := /home/phantomwise/SynologyDrive/Personal
HOME_DIR := /home/phantomwise

# Default TARGET
TARGET ?= all

# restow
restow:
	@echo -e "\033[1;33mRestowing ${TARGET}\033[0m"
ifeq ($(TARGET),all)
	stow -v --restow --dir=$(CONFIG_DIR) home --target=$(HOME_DIR)
	sudo stow -v --restow --dir=$(CONFIG_DIR) etc --target=/etc
	sudo stow -v --restow --dir=$(CONFIG_DIR) usr --target=/usr
	stow -v --restow --dir=$(PERSONAL_DIR) . --target=$(HOME_DIR)
else ifeq ($(TARGET),home)
	stow -v --restow --dir=$(CONFIG_DIR) home --target=$(HOME_DIR)
else ifeq ($(TARGET),etc)
	sudo stow -v --restow --dir=$(CONFIG_DIR) etc --target=/etc
else ifeq ($(TARGET),usr)
	sudo stow -v --restow --dir=$(CONFIG_DIR) usr --target=/usr
else ifeq ($(TARGET),personal)
	stow -v --restow --dir=$(PERSONAL_DIR) . --target=$(HOME_DIR)
else
	@echo -e "\033[1;31mInvalid target '${TARGET}'\033[0m"
	@echo -e "\033[1;31mValid options: all, home, etc, usr\033[0m"
	@false
endif

# nix-cleanup
nix-cleanup:

	@echo -e "\033[1;33mDeleting old system generations (keep last 10)\033[0m"
	sudo nix-env --delete-generations +10 --profile /nix/var/nix/profiles/system
	@echo -e "\033[1;33mDeleting old user generations (keep last 10)\033[0m"
	nix-env --delete-generations +10
	@echo -e "\033[1;33mCleaning up unused system paths\033[0m"
	sudo nix-collect-garbage --delete-older-than 7d
	@echo -e "\033[1;33mCleaning up unused user paths\033[0m"
	nix-collect-garbage --delete-older-than 7d
	@echo -e "\033[1;33mDeduplication\033[0m"
	sudo nix-store --optimise
	@echo -e "\033[1;33mListing remaining user generations\033[0m"
	nix-env --list-generations
	@echo -e "\033[1;33mListing remaining system generations\033[0m"
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# nix-update
nix-update:
	@echo -e "\033[1;33mUpdating channels\033[0m"
	nix-channel --update
	@echo -e "\033[1;33mRebuilding\033[0m"
	sudo nixos-rebuild switch
