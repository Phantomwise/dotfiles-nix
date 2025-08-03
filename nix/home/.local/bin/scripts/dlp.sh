#!/usr/bin/env bash

# Description:
# Wrapper script to run yt-dlp with predefined options on any URL
# Required: yt-dlp

# Define variables for error messages
info="\033[1;33m[INFO]\033[0m"
succ="\033[1;32m[SUCCESS]\033[0m"
err="\033[1;31m[ERROR]\033[0m"

# Prompt user for URL input
read -e -p "Enter URL to download: " url

# Function to download video with subtitles using yt-dlp
download_video_w_sub() {
    echo -e "${info} Running yt-dlp to download video with subtitles:"
    yt-dlp --write-subs --sub-langs "all" --impersonate="chrome:windows-10" --sleep-interval 20 --max-sleep-interval 40 --limit-rate 600K "$url" && \
    echo -e "${succ} Download completed successfully." || \
    { echo -e "${err} Error during download."; return 1; }
}

# Run the download function
download_video_w_sub
