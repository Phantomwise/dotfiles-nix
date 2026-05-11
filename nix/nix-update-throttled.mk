# Declare phony targets
.PHONY: nix-update-throttled

# Default CPU quota (percent of one logical CPU)
#   Override:
#   make nix-rebuild-throttled CPUQUOTA=75%
CPUQUOTA ?= 50%

# nix-update-throttled
nix-update-throttled:
	@echo -e "\033[1;33mUpdating channels\033[0m"
	nix-channel --update
	sudo nix-channel --update
	@echo -e "\033[1;33mUpgrading system configuration (throttled to $(CPUQUOTA))\033[0m"
	sudo systemd-run --scope -p CPUQuota=$(CPUQUOTA) \
		--description="throttled nixos update" \
		sh -c "NINJAFLAGS='-j1' MAKEFLAGS='-j1' CARGO_BUILD_JOBS=1 nixos-rebuild switch --upgrade"
	@echo -e "\033[1;33mRebuilding Home Manager configuration\033[0m"
	home-manager switch
	@echo -e "\033[1;32mUpdate complete\033[0m"
	nvd diff $$(ls -d /nix/var/nix/profiles/system-*-link | tail -2)
