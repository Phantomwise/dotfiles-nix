# Declare all phony (non-file) targets here
.PHONY: restow

# Declare directories
CONFIG_DIR := /home/phantomwise/SynologyDrive/dotfiles-nix/nix
PERSONAL_DIR := /home/phantomwise/SynologyDrive/Personal
HOME_DIR := /home/phantomwise

# restow
restow:
	@echo "Restowing $HOME directory"
	stow -v --restow --dir=$(CONFIG_DIR) home --target=$(HOME_DIR)
	@echo "Restowing /etc directory"
	sudo stow -v --restow --dir=$(CONFIG_DIR) etc --target=/etc
	@echo "Restowing /usr directory"
	sudo stow -v --restow --dir=$(CONFIG_DIR) usr --target=/usr
	@echo "Restowing personal directory"
	stow -v --restow --dir=$(PERSONAL_DIR) . --target=$(HOME_DIR)

# stow -v --restow --dir=/home/phantomwise/SynologyDrive/dotfiles-nix/nix home --target=/home/phantomwise/
# sudo stow -v --restow --dir=/home/phantomwise/SynologyDrive/dotfiles-nix/nix etc --target=/etc
# sudo stow -v --restow --dir=/home/phantomwise/SynologyDrive/dotfiles-nix/nix usr --target=/usr
# stow -v --restow --dir=/home/phantomwise/SynologyDrive/Personal . --target=/home/phantomwise/

