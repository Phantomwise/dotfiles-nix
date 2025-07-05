# Declare all phony (non-file) targets here
.PHONY: restow nix-cleanup

# Declare directories
CONFIG_DIR := /home/phantomwise/SynologyDrive/dotfiles-nix/nix
PERSONAL_DIR := /home/phantomwise/SynologyDrive/Personal
HOME_DIR := /home/phantomwise

# restow
restow:
	@echo -e "\033[1;33mRestowing $HOME directory\033[0m"
	stow -v --restow --dir=$(CONFIG_DIR) home --target=$(HOME_DIR)
	@echo -e "\033[1;33mRestowing /etc directory\033[0m"
	sudo stow -v --restow --dir=$(CONFIG_DIR) etc --target=/etc
	@echo -e "\033[1;33mRestowing /usr directory\033[0m"
	sudo stow -v --restow --dir=$(CONFIG_DIR) usr --target=/usr
	@echo -e "\033[1;33mRestowing personal directory\033[0m"
	stow -v --restow --dir=$(PERSONAL_DIR) . --target=$(HOME_DIR)

# stow -v --restow --dir=/home/phantomwise/SynologyDrive/dotfiles-nix/nix home --target=/home/phantomwise/
# sudo stow -v --restow --dir=/home/phantomwise/SynologyDrive/dotfiles-nix/nix etc --target=/etc
# sudo stow -v --restow --dir=/home/phantomwise/SynologyDrive/dotfiles-nix/nix usr --target=/usr
# stow -v --restow --dir=/home/phantomwise/SynologyDrive/Personal . --target=/home/phantomwise/

# nix-cleanup
nix-cleanup:

	@echo -e "\033[1;33mDeleting old system generations (keep last 10)\033[0m"
	sudo nix-env --delete-generations +10 --profile /nix/var/nix/profiles/system
	@echo -e "\033[1;33mDeleting old user generations (keep last 10)\033[0m"
	nix-env --delete-generations +10
	@echo -e "\033[1;33mCleaning up unused system paths\033[0m"
	sudo nix-collect-garbage
	@echo -e "\033[1;33mCleaning up unused user paths\033[0m"
	nix-collect-garbage
	@echo -e "\033[1;33mDeduplication\033[0m"
	sudo nix-store --optimise
	@echo -e "\033[1;33mList remaining generations\033[0m"
	nix-env --list-generations
