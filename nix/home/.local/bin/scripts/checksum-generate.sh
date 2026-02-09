#!/usr/bin/env bash

# Description:
    # Generates MD5 and/or SHA256 checksums for a specified file or all regular files in the current directory because I'm too lazy to use the command manually.
# Usage:
    # checksum.sh <md5|sha256|all> <target_file|all>
# AI Disclaimer:
    # This script was written with help from an AI language model.

# Define color codes
declare -r red="\033[0;31m"      # Error messages
declare -r green="\033[0;32m"    # Success messages
declare -r yellow="\033[0;33m"   # Information messages
declare -r blue="\033[0;34m"     # Files and paths
declare -r magenta="\033[0;35m"  # Debug messages
declare -r cyan="\033[0;36m"     # Keywords
declare -r reset="\033[0m"       # Reset

# Usage helper
usage() {
    echo -e "${red}Usage:${reset} $0 <md5|sha256|all> <target_file|all>"
    exit 1
}

# Require exactly two args
if [ "$#" -ne 2 ]; then
    usage
fi

HASH_TYPE="$1"
TARGET="$2"

do_md5() {
    local target="$1"
    local target_dir filename out

    if [ ! -f "$target" ]; then
        echo -e "${red}Error:${reset} File ${blue}'$target'${reset} does not exist or is not a regular file"
        return 4
    fi

    if ! command -v md5sum >/dev/null 2>&1; then
        echo -e "${red}Error:${reset} md5sum not found"
        return 2
    fi

    target_dir=$(dirname -- "$target")
    filename=$(basename -- "$target")
    out="${target_dir}/${filename}.md5"

    if md5sum "$target" > "$out"; then
        echo -e "${green}Success:${reset} MD5 checksum saved to: ${blue}$out${reset}"
        return 0
    else
        echo -e "${red}Error:${reset} MD5 generation failed for ${blue}$target${reset}"
        return 3
    fi
}

# Functions that operate on a single file path
do_sha256() {
    local target="$1"
    local target_dir filename out

    if [ ! -f "$target" ]; then
        echo -e "${red}Error:${reset} File ${blue}'$target'${reset} does not exist or is not a regular file"
        return 4
    fi

    if ! command -v sha256sum >/dev/null 2>&1; then
        echo -e "${red}Error:${reset} sha256sum not found"
        return 2
    fi

    target_dir=$(dirname -- "$target")
    filename=$(basename -- "$target")
    out="${target_dir}/${filename}.sha256"

    if sha256sum "$target" > "$out"; then
        echo -e "${green}Success:${reset} SHA256 checksum saved to: ${blue}$out${reset}"
        return 0
    else
        echo -e "${red}Error:${reset} SHA256 generation failed for ${blue}$target${reset}"
        return 3
    fi
}

# Process a single file according to HASH_TYPE (md5, sha256, or all)
process_file() {
    local file="$1"
    case "$HASH_TYPE" in
        md5)
            do_md5 "$file"
            return $?
            ;;
        sha256)
            do_sha256 "$file"
            return $?
            ;;
        all)
            do_md5 "$file"
            local rc_md5=$?
            do_sha256 "$file"
            local rc_sha=$?
            # If either failed, report non-zero
            if [ $rc_sha -ne 0 ] || [ $rc_md5 -ne 0 ]; then
                return 1
            fi
            return 0
            ;;
        *)
            echo -e "${red}Error:${reset} Hash type must be ${cyan}'sha256'${reset}, ${cyan}'md5'${reset}, or ${cyan}'all'${reset}"
            return 1
            ;;
    esac
}

# If TARGET is not the literal string "all", treat it as a file path and run on that file only
if [ "$TARGET" != "all" ]; then
    if [ ! -f "$TARGET" ]; then
        echo -e "${red}Error:${reset} File ${blue}'$TARGET'${reset} does not exist"
        exit 1
    fi

    process_file "$TARGET"
    rc=$?
    if [ $rc -eq 0 ]; then
        echo -e "${green}Done:${reset} Checksum(s) generated successfully."
    fi
    exit $rc
fi

# TARGET == "all" -> run on all regular files in the current working directory (non-recursive)
overall_status=0
# find . -maxdepth 1 -type f -print0 will include hidden files and avoid directories
while IFS= read -r -d '' f; do
    # skip the script file itself if it's in the same directory and you don't want it processed
    # (optional) Uncomment the next two lines to skip processing this script file:
    # if [ "$(realpath "$f")" = "$(realpath "$0")" ]; then
    #     continue
    # fi

    process_file "$f"
    rc=$?
    if [ $rc -ne 0 ]; then
        overall_status=1
    fi
done < <(find . -maxdepth 1 -type f ! -name '*.md5' ! -name '*.sha256' -print0)

if [ $overall_status -ne 0 ]; then
    echo -e "${red}Done:${reset} One or more checksums failed."
    exit 2
fi

echo -e "${green}Done:${reset} Checksum(s) generated successfully for all files."
exit 0