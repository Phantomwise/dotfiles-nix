# Declare phony targets

# Declare color variables
BLACK  := \033[0;30m
RED    := \033[0;31m
GREEN  := \033[0;32m
YELLOW := \033[0;33m
BLUE   := \033[0;34m
PURPLE := \033[0;35m
CYAN   := \033[0;36m
WHITE  := \033[0;37m
RESET  := \033[0m

# Declare directories
CONFIG_DIR := /home/phantomwise/Sync/dotfiles-nix/nix
PERSONAL_DIR := /home/phantomwise/Sync/Personal
HOME_DIR := /home/phantomwise

# Include modular Makefile parts
include nix-cleanup.mk
include nix-info.mk
include nix-rebuild.mk
include rclone.mk
include rclone-games.mk
include stow.mk
