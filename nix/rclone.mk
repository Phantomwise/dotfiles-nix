# Declare phony targets
.PHONY: rclone

# Declare directories
SYNC_SRC_DIR := /home/phantomwise/Sync/

# Sync with rclone
rclone:
	@echo -e "\033[1;33mSyncing Firefox\033[0m"
	rclone sync -v /home/phantomwise/.mozilla/firefox/h0gi4v0t.Phantomwise/ $(SYNC_SRC_DIR)/Additional/Firefox
	@echo -e "\033[1;33mSyncing to NAS\033[0m"
	rclone sync -v $(SYNC_SRC_DIR) NAS:personal/Sync/Dell-Latitude-E5530-Nix-Rclone
