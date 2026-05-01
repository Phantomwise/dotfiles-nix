# Declare phony targets
.PHONY: nix-rebuild-throttled

# Default CPU quota (percent of one logical CPU)
#   Override:
#   make nix-rebuild-throttled CPUQUOTA=75%
CPUQUOTA ?= 50%

# nix-rebuild
nix-rebuild:
	@echo -e "\033[1;33mRebuilding system configuration (throttled to $(CPUQUOTA))\033[0m"
	sudo systemd-run --scope -p CPUQuota=$(CPUQUOTA) \
		--description="throttled nixos-rebuild" \
		sh -c "NINJAFLAGS='-j1' MAKEFLAGS='-j1' CARGO_BUILD_JOBS=1 nixos-rebuild switch"
	@echo -e "\033[1;33mRebuilding Home Manager configuration\033[0m"
	home-manager switch
	@echo -e "\033[1;33mRefreshing font cache\033[0m"
	fc-cache -fv
	@echo -e "\033[1;32mThrottled rebuild complete\033[0m"
	nvd diff $$(ls -d /nix/var/nix/profiles/system-*-link | tail -2)
