# Declare phony targets
.PHONY: restow unstow

# Default TARGET
TARGET ?= all

# restow
restow:
	@echo -e "\033[1;33mRestowing ${TARGET}\033[0m"
ifeq ($(TARGET),all)
	stow -v --restow --dir=$(CONFIG_DIR) home --target=$(HOME_DIR)
	sudo stow -v --restow --dir=$(CONFIG_DIR) etc --target=/etc
	sudo stow -v --restow --dir=$(CONFIG_DIR) usr --target=/usr
	stow -v --restow --dir=$(PERSONAL_DIR) home --target=$(HOME_DIR)
	stow -v --restow --adopt --dir=$(PERSONAL_DIR) home-adopt --target=$(HOME_DIR)
else ifeq ($(TARGET),home)
	# Restow dotfiles-nix/home
	stow -v --restow --dir=$(CONFIG_DIR) home --target=$(HOME_DIR)
else ifeq ($(TARGET),etc)
	# Restow dotfiles-nix/etc
	sudo stow -v --restow --dir=$(CONFIG_DIR) etc --target=/etc
else ifeq ($(TARGET),usr)
	# Restow dotfiles-nix/usr
	sudo stow -v --restow --dir=$(CONFIG_DIR) usr --target=/usr
else ifeq ($(TARGET),personal)
	# Restow Personal/home
	stow -v --restow --dir=$(PERSONAL_DIR) home --target=$(HOME_DIR)
else ifeq ($(TARGET),personal-adopt)
	# Restow Personal/home-adopt (for pesky apps who break symlinks on their configs)
	stow -v --restow --adopt --dir=$(PERSONAL_DIR) home-adopt --target=$(HOME_DIR)
else ifeq ($(TARGET),adopt)
	# Restow Personal/home-adopt (for pesky apps who break symlinks on their configs)
	stow -v --restow --adopt --dir=$(PERSONAL_DIR) home-adopt --target=$(HOME_DIR)
else
	@echo -e "\033[1;31mInvalid target '${TARGET}'\033[0m"
	@echo -e "\033[1;31mValid options: all, home, etc, usr, personal, personal-adopt, adopt\033[0m"
	@false
endif

# unstow
unstow:
	@echo -e "\033[1;33mDeleting ${TARGET}\033[0m"
ifeq ($(TARGET),all)
	stow -v --delete --dir=$(CONFIG_DIR) home --target=$(HOME_DIR)
	sudo stow -v --delete --dir=$(CONFIG_DIR) etc --target=/etc
	sudo stow -v --delete --dir=$(CONFIG_DIR) usr --target=/usr
	stow -v --delete --dir=$(PERSONAL_DIR) home --target=$(HOME_DIR)
	stow -v --delete --dir=$(PERSONAL_DIR) home-adopt --target=$(HOME_DIR)
else ifeq ($(TARGET),home)
	# Restow dotfiles-nix/home
	stow -v --delete --dir=$(CONFIG_DIR) home --target=$(HOME_DIR)
else ifeq ($(TARGET),etc)
	# Restow dotfiles-nix/etc
	sudo stow -v --delete --dir=$(CONFIG_DIR) etc --target=/etc
else ifeq ($(TARGET),usr)
	# Restow dotfiles-nix/usr
	sudo stow -v --delete --dir=$(CONFIG_DIR) usr --target=/usr
else ifeq ($(TARGET),personal)
	# Restow Personal/home
	stow -v --delete --dir=$(PERSONAL_DIR) home --target=$(HOME_DIR)
else ifeq ($(TARGET),personal-adopt)
	# Restow Personal/home-adopt (for pesky apps who break symlinks on their configs)
	stow -v --delete --dir=$(PERSONAL_DIR) home-adopt --target=$(HOME_DIR)
else ifeq ($(TARGET),adopt)
	# Restow Personal/home-adopt (for pesky apps who break symlinks on their configs)
	stow -v --delete --dir=$(PERSONAL_DIR) home-adopt --target=$(HOME_DIR)
else
	@echo -e "\033[1;31mInvalid target '${TARGET}'\033[0m"
	@echo -e "\033[1;31mValid options: all, home, etc, usr, personal, personal-adopt, adopt\033[0m"
	@false
endif
