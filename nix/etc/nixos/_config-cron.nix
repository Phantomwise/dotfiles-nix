{ config, pkgs, ... }:

{
  services.cron = {
    enable = true;

    systemCronJobs = [
    # System-wide cron jobs (run as root)
      # System-wide cron job running as root
      {
        minute = "0";
        hour = "*/12";
        command = "/home/phantomwise/.local/bin/scripts/dunst/uptime.sh";
      },
      # User-specific cron job running as phantomwise
      {
        user = "phantomwise";
        minute = "*/30";
        hour = "*";
        command = "rclone sync -v /home/phantomwise/Sync/SynologyDrive NAS:personal/Sync/Dell-Latitude-E5530-Nix-Rclone";
      }
    ];
  };
}
