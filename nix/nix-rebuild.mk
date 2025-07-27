# Declare phony targets
.PHONY: nix-rebuild

# nix-rebuild
nix-rebuild:
	@echo -e "\033[1;33mRebuilding system configuration\033[0m"
	sudo nixos-rebuild switch
	@echo -e "\033[1;33mRebuilding Home Manager configuration\033[0m"
	home-manager switch
	@echo -e "\033[1;33mRefresh font cache\033[0m"
	fc-cache -fv