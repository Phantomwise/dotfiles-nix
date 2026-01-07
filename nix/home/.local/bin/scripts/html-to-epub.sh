#!/usr/bin/env bash

# AI Disclaimer: This script was written with help from an AI language model.

# Script to download a webpage, extract content, and convert to EPUB.
# Requires: wget, html-xml-utils (hxnormalize, hxselect, hxremove), pandoc

# Define color codes
declare -r red="\033[0;31m"
declare -r green="\033[0;32m"
declare -r yellow="\033[0;33m"
declare -r blue="\033[0;34m"
declare -r magenta="\033[0;35m"
declare -r cyan="\033[0;36m"
declare -r reset="\033[0m"

set -e  # Exit on any error

# Function to display usage
usage() {
    echo "Usage: $0 [-d SELECTOR] [-a AUTHOR]"
    echo "Download a webpage, extract content, and convert to EPUB."
    echo ""
    echo "Options:"
    echo "  -d SELECTOR    CSS selector for page content (e.g., 'div.content')."
    echo "                 If not provided, you'll be prompted."
    echo "  -a AUTHOR      Author name (e.g., 'John Doe')."
    echo "                 If not provided, you'll be prompted."
    echo "  -h             Show this help message."
    echo ""
    echo "You'll be prompted for URL, title, and any missing inputs."
    echo "Output: EPUB file named 'author_-_title_(source).epub' (sanitized)."
    exit 1
}

# Parse options with getopts
DIV_SELECTOR=""
AUTHOR=""
while getopts "d:a:h" opt; do
    case $opt in
        d) DIV_SELECTOR="$OPTARG" ;;
        a) AUTHOR="$OPTARG" ;;
        h) usage ;;
        *) usage ;;
    esac
done

# Check for required tools (optional, but helpful)
for tool in wget hxnormalize hxselect hxremove pandoc; do
    if ! command -v "$tool" &> /dev/null; then
        echo -e "${red}ERROR:${reset} ${cyan}$tool${reset} is not installed. Please install it."
        exit 1
    fi
done

# Prompt for inputs
read -e -p "Enter the webpage URL: " URL
if [[ -z "$URL" ]]; then
    echo -e "${red}ERROR:${reset} URL is required."
    exit 1
fi

if [[ -z "$DIV_SELECTOR" ]]; then
    read -e -p "Enter the CSS selector for page content (e.g., div.content): " DIV_SELECTOR
    if [[ -z "$DIV_SELECTOR" ]]; then
        echo -e "${red}ERROR:${reset} Selector is required."
        exit 1
    fi
fi

read -e -p "Enter the page title: " TITLE
if [[ -z "$TITLE" ]]; then
    echo -e "${red}ERROR:${reset} Title is required."
    exit 1
fi

if [[ -z "$AUTHOR" ]]; then
    read -e -p "Enter the author: " AUTHOR
    if [[ -z "$AUTHOR" ]]; then
        echo -e "${red}ERROR:${reset} Author is required."
        exit 1
    fi
fi

# Extract and sanitize source (full domain from URL, with dots replaced by underscores)
DOMAIN=$(echo "$URL" | sed -E 's|https?://([^/]+).*|\1|' | sed 's/^www\.//' | sed 's/\./_/g' | tr '[:upper:]' '[:lower:]')

# Sanitize author and title for filename (replace spaces/special chars with underscores, lowercase; keep &)
SANITIZED_AUTHOR=$(echo "$AUTHOR" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9&]/_/g' | sed 's/__*/_/g' | sed 's/^_\|_$//g')
SANITIZED_TITLE=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g' | sed 's/__*/_/g' | sed 's/^_\|_$//g')
OUTPUT_FILE="${SANITIZED_AUTHOR}_-_${SANITIZED_TITLE}_(${DOMAIN}).epub"

# Create temp files
TEMP_HTML=$(mktemp)
TEMP_CLEAN=$(mktemp)

# Cleanup function
cleanup() {
    rm -f "$TEMP_HTML" "$TEMP_CLEAN"
}
trap cleanup EXIT

# Step 1: Download
echo -e "${yellow}INFO:${reset} Downloading text from ${blue}$URL${reset} ..."
wget -q -O "$TEMP_HTML" "$URL"

# Step 2: Extract and clean
echo -e "${yellow}INFO:${reset} Extracting and cleaning content..."
hxnormalize -x "$TEMP_HTML" | hxselect "$DIV_SELECTOR" | hxremove 'div.addtoany_share_save_container' > "$TEMP_CLEAN"

# Check if extraction worked (basic check: file not empty)
if [[ ! -s "$TEMP_CLEAN" ]]; then
    echo -e "${red}ERROR:${reset} No content found with selector ${cyan}'$DIV_SELECTOR'${reset}. Check the webpage source."
    exit 1
fi

# Step 3: Convert to EPUB
echo -e "${yellow}INFO:${reset} Converting to EPUB..."
pandoc -f html -t epub "$TEMP_CLEAN" -o "$OUTPUT_FILE" --metadata title="$TITLE" --metadata author="$AUTHOR"

echo -e "${green}SUCCESS:${reset} EPUB saved as: ${cyan}$OUTPUT_FILE${reset}"
