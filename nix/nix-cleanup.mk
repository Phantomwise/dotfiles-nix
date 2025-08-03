# Declare phony targets
.PHONY: nix-cleanup

# nix-cleanup
nix-cleanup:

	@echo -e "\033[1;33mUninstall unused flatpak dependencies\033[0m"
	flatpak uninstall --unused
	@echo -e "\033[1;33mDeleting old system generations (keep last 10)\033[0m"
	sudo nix-env --delete-generations +10 --profile /nix/var/nix/profiles/system
	@echo -e "\033[1;33mDeleting old user generations (keep last 10)\033[0m"
	nix-env --delete-generations +10
	@echo -e "\033[1;33mCleaning up unused system paths\033[0m"
	sudo nix-collect-garbage --delete-older-than 7d
	@echo -e "\033[1;33mCleaning up unused user paths\033[0m"
	nix-collect-garbage --delete-older-than 7d
	@echo -e "\033[1;33mDeleting old home manager generations (keep last 7 days)\033[0m"
	home-manager expire-generations "-7 days"
	@echo -e "\033[1;33mDeduplication\033[0m"
	sudo nix-store --optimise
	@echo -e "\033[1;33mListing remaining user generations\033[0m"
	nix-env --list-generations
	@echo -e "\033[1;33mListing remaining system generations\033[0m"
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
