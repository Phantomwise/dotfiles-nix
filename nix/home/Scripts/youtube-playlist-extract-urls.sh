#!/usr/bin/env bash

# List of required commands
dependencies=(
    yt-dlp
    jq
)

# Check if each dependency is installed
for cmd in "${dependencies[@]}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: $cmd is required but not installed. Exiting."
        exit 1
    fi
done

# Ask user for YouTube playlist URL
read -p "Enter YouTube playlist URL: " url

# Extract playlist ID for filename
playlist_id=$(echo "$url" | grep -oP "(?<=list=)[^&]+")

# Make filename safe by removing problematic characters
safe_playlist_id=$(echo "$playlist_id" | tr -cd '[:alnum:]_-')

if [ -z "$safe_playlist_id" ]; then
    echo "Could not extract playlist ID from URL."
    exit 1
fi

# Extract video URLs and save to PlaylistID.txt
yt-dlp -j --flat-playlist "$url" | jq -r '.id' | sed "s_^_https://www.youtube.com/watch?v=_" > "${safe_playlist_id}.txt"

echo "Saved all video links to ${safe_playlist_id}.txt"
