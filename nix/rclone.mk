# Declare phony targets
.PHONY: rclone

# Declare directories
SYNC_SRC_DIR := /home/phantomwise/Sync/

# Sync with rclone

rclone:
	@echo -e "\033[1;33mTemporarily changing ownership of the Secrets folder\033[0m"
	sudo chown -R phantomwise $(SYNC_SRC_DIR)Personal/home/Secrets
	@echo -e "\033[1;33mSyncing to NAS\033[0m"
	rclone sync -v $(SYNC_SRC_DIR) NAS:personal/Sync/Dell-Latitude-E5530-Nix-Rclone
	@echo -e "\033[1;33mReverting ownership\033[0m"
	sudo chown -R root:root $(SYNC_SRC_DIR)Personal/home/Secrets
	@echo -e "\033[1;33mSyncing to NAS (Projects)\033[0m"
	rclone sync -v $(SYNC_SRC_DIR)Personal/home/Projects NAS:personal/Projects

rclone-all:
	@echo -e "\033[1;33mSyncing Firefox to Sync folder\033[0m"
	rclone sync -v /home/phantomwise/.config/mozilla/firefox $(SYNC_SRC_DIR)/Additional/Firefox
	$(MAKE) rclone
	$(MAKE) rclone-vim

rclone-zim:
	@echo -e "\033[1;33mSyncing vim archives\033[0m"
	rclone sync -v /mnt/wdc20tb/Downloads/kiwix/ NAS:media/Archives/zims
