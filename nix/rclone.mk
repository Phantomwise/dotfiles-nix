# Declare phony targets
.PHONY: rclone

# Declare directories
SYNC_SRC_DIR := /home/phantomwise/Sync/SynologyDrive

# Sync with rclone
rclone:
	@echo -e "\033[1;33mSyncing\033[0m"
	rclone sync -v $(SYNC_SRC_DIR) NAS:personal/Sync/Dell-Latitude-E5530-Nix-Rclone
