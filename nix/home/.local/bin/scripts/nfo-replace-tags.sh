#!/usr/bin/env bash

# Define color codes
declare -r red="\033[0;31m"
declare -r green="\033[0;32m"
declare -r yellow="\033[0;33m"
declare -r blue="\033[0;34m"
declare -r purple="\033[0;35m"
declare -r cyan="\033[0;36m"
declare -r reset="\033[0m"

# Check if exactly two arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 \"Old Tag\" \"New Tag\""
    echo "If the second argument is an empty string \"\", the matching lines will be removed."
    exit 1
fi

old_tag="$1"
new_tag="$2"

# Find all movie.nfo and tvshow.nfo files that contain the old tag
files=$(find . -type f \( -name "movie.nfo" -o -name "tvshow.nfo" \) -exec grep -l "<tag>$old_tag</tag>" {} \;)
# Find all .nfo files that contain the old tag
# files=$(find . -name "*.nfo" -type f -exec grep -l "<tag>$old_tag</tag>" {} \;)

if [ -z "$files" ]; then
    echo -e "${yellow}No files found containing the tag '<tag>$old_tag</tag>'.${reset}"
    exit 0
fi

echo -e "${yellow}Files to process:${reset}"
echo "$files" | sed 's|^\./||'  # Remove leading ./ for cleaner output

echo ""
echo -e "${yellow}Processing...${reset}"

# Process each file
echo "$files" | while read -r file; do
    if [ -z "$new_tag" ]; then
        # Remove the entire line containing the old tag
        sed -i "/<tag>$old_tag<\/tag>/d" "$file"
        echo -e "${green}SUCCESS:${reset} ${cyan}$old_tag${reset} removed from ${blue}$file${reset}"
    else
        # Replace the old tag with the new tag
        sed -i "s|<tag>$old_tag</tag>|<tag>$new_tag</tag>|g" "$file"
        echo -e "${green}SUCCESS:${reset} ${cyan}$old_tag${reset} replaced by ${cyan}$new_tag${reset} in ${blue}$file${reset}"
    fi
done

echo ""
echo -e "${green}Operation completed.${reset}"