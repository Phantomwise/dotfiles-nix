#!/bin/bash

# AI Disclaimer:
# This script was written with help from GitHub Copilot.

# Check if ffprobe is installed
if ! command -v ffprobe &> /dev/null; then
    echo "ffprobe is not installed. Please install FFmpeg to use this script."
    exit 1
fi

# Find all files in the current directory and process them
find . -maxdepth 1 -type f | sort | while IFS= read -r file; do
    # Get the resolution using ffprobe, suppress errors for unsupported files
    resolution=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "$file" 2>/dev/null)
    if [ -n "$resolution" ]; then
        echo "$resolution,$file"
    # else
        # echo "Unsupported or invalid file: $file"
    fi
done | awk -F, '{ printf "%-2s %-5s %s\n", $1, $2, $3 }'