# Declare phony targets
.PHONY: nix-update

# Declare directories
CONFIG_DIR := /home/phantomwise/SynologyDrive/dotfiles-nix/nix
PERSONAL_DIR := /home/phantomwise/SynologyDrive/Personal
HOME_DIR := /home/phantomwise

# Default TARGET
TARGET ?= all

# Include modular Makefile parts
include nix-cleanup.mk
include nix-update.mk

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
