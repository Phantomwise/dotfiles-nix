#!/usr/bin/env bash

# Description: Script to validate checksums
# - Runs `md5sum -c <file>.md5` for each .md5 file (one-by-one) and prints per-file success/failure
# - Runs `sha256sum -c <file>.sha256` for each .sha256 file (one-by-one) and prints per-file success/failure
# - Runs `sha512sum -c <file>.sha512` for each .sha512 file (one-by-one) and prints per-file success/failure
# - By default, skips device files (/dev/*) for safety and speed
# Usage: validate_checksums.sh [options] [directory]
#   If no directory is specified, uses current directory
#   Verifies checksums of all `.md5`, `.sha256`, and `.sha512` files (non-recursive)
# Exits with status 0 if all checks pass, non-zero if any check fails.
# AI Disclaimer: This script was written with help from an AI language model.

set -o pipefail
set -u

# Default options
declare include_devices=0
declare target_dir="."

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            echo "Usage: $0 [options] [directory]"
            echo ""
            echo "Validates all .md5, .sha256, and .sha512 checksum files in the specified directory."
            echo "If no directory is specified, uses the current directory."
            echo ""
            echo "Options:"
            echo "  -h, --help           Show this help message"
            echo "  --include-devices    Include device files (/dev/*) in validation"
            echo "                       By default, device files are skipped for safety"
            echo ""
            echo "Exit codes:"
            echo "  0    All checksum verifications passed"
            echo "  1    One or more checksum verifications failed"
            echo "  2    Required utilities not found"
            exit 0
            ;;
        --include-devices)
            include_devices=1
            shift
            ;;
        -*)
            echo "Error: Unknown option $1" >&2
            echo "Use -h or --help for usage information" >&2
            exit 1
            ;;
        *)
            target_dir="$1"
            shift
            ;;
    esac
done

# Change to target directory
cd "$target_dir" || { 
    echo "Error: Cannot access directory: $target_dir" >&2
    exit 1
}

if [[ "$target_dir" != "." ]]; then
    echo "Working in directory: $target_dir"
fi

# Define color codes
declare -r red="\033[0;31m"      # Error messages
declare -r green="\033[0;32m"    # Success messages
declare -r yellow="\033[0;33m"   # Information messages
declare -r blue="\033[0;34m"     # Files and paths
declare -r magenta="\033[0;35m"  # Debug messages
declare -r cyan="\033[0;36m"     # Keywords
declare -r reset="\033[0m"       # Reset

# Check availability of required programs
declare md5sum_missing=0
declare sha256sum_missing=0
declare sha512sum_missing=0

if ! command -v md5sum >/dev/null 2>&1; then
  md5sum_missing=1
fi

if ! command -v sha256sum >/dev/null 2>&1; then
  sha256sum_missing=1
fi

if ! command -v sha512sum >/dev/null 2>&1; then
  sha512sum_missing=1
fi

if [ "${md5sum_missing:-0}" -eq 1 ] && [ "${sha256sum_missing:-0}" -eq 1 ] && [ "${sha512sum_missing:-0}" -eq 1 ]; then
  echo -e "${red}None of md5sum, sha256sum, or sha512sum were found in PATH.${reset}" >&2
  exit 2
fi

shopt -s nullglob

declare -a md5_files
declare -a sha256_files
declare -a sha512_files
md5_files=( *.md5 )
sha256_files=( *.sha256 )
sha512_files=( *.sha512 )

declare rc=0

# Cleanup temp files on exit
declare -a temp_files=()
cleanup() {
  for temp_file in "${temp_files[@]}"; do
    rm -f "$temp_file"
  done
}
trap cleanup EXIT

# Helper: Filter device files from checksum file if needed
# Arguments:
#   $1 = original checksum file path
#   $2 = output variable name for filtered file path
#   $3 = output variable name for skipped count
filter_devices() {
  local original_file="$1"
  local -n filtered_file_ref=$2
  local -n skipped_count_ref=$3
  
  skipped_count_ref=0
  
  if [ "$include_devices" -eq 1 ]; then
    # No filtering needed
    filtered_file_ref="$original_file"
    return 0
  fi
  
  # Create filtered version
  local temp_filtered
  temp_filtered="$(mktemp)" || temp_filtered="/tmp/validate-checksums-filtered.$$"
  temp_files+=("$temp_filtered")
  
  # Process line by line, skip /dev/ entries and report them
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" =~ ^[[:space:]]*[a-fA-F0-9]+[[:space:]]+/dev/ ]]; then
      # Extract the device path for reporting
      local device_path
      device_path=$(echo "$line" | sed 's/^[[:space:]]*[a-fA-F0-9]*[[:space:]]*\(.*\)$/\1/')
      echo -e "  ${yellow}SKIPPED:${reset} ${device_path} ${cyan}(device file, use --include-devices to validate)${reset}"
      ((skipped_count_ref++))
    else
      echo "$line" >> "$temp_filtered"
    fi
  done < "$original_file"
  
  filtered_file_ref="$temp_filtered"
}

# Helper: run verifier on a single checksum file, stream its output, and report OK/FAIL for the checksum file.
# Arguments:
#   $1 = checksum program (md5sum, sha256sum, or sha512sum)
#   $2 = checksum file path
run_single_check() {
  local verifier="$1"
  local chkfile="$2"
  local filtered_file
  local skipped_count
  local tmp

  echo -e "${yellow}Verifying:${reset} ${blue}${chkfile}${reset} ..."
  
  # Filter device files if necessary
  filter_devices "$chkfile" filtered_file skipped_count
  
  tmp="$(mktemp)" || tmp="/tmp/validate-checksums.$$"
  temp_files+=("$tmp")

  # Run verifier on the (possibly filtered) file
  if "${verifier}" -c -- "${filtered_file}" >"${tmp}" 2>&1; then
    local verified_count=0
    while IFS= read -r line; do
      echo -e "  ${line}"
      if [[ "$line" =~ :[[:space:]]*OK$ ]]; then
        ((verified_count++))
      fi
    done <"${tmp}"
    
    # Build status message
    local status_msg="${chkfile}"
    if [ "$verified_count" -gt 0 ] && [ "$skipped_count" -gt 0 ]; then
      status_msg="${chkfile} (${verified_count} verified, ${skipped_count} skipped)"
    elif [ "$skipped_count" -gt 0 ]; then
      status_msg="${chkfile} (${skipped_count} skipped)"
    fi
    
    echo -e "${green}OK:${reset} ${status_msg}"
    return 0
  else
    local verified_count=0
    local failed_count=0
    while IFS= read -r line; do
      echo -e "  ${line}"
      if [[ "$line" =~ :[[:space:]]*OK$ ]]; then
        ((verified_count++))
      elif [[ "$line" =~ :[[:space:]]*FAILED ]]; then
        ((failed_count++))
      fi
    done <"${tmp}"
    
    # Build status message  
    local status_msg="${chkfile}"
    if [ "$failed_count" -gt 0 ] || [ "$verified_count" -gt 0 ] || [ "$skipped_count" -gt 0 ]; then
      local parts=()
      [ "$verified_count" -gt 0 ] && parts+=("${verified_count} verified")
      [ "$failed_count" -gt 0 ] && parts+=("${failed_count} failed")
      [ "$skipped_count" -gt 0 ] && parts+=("${skipped_count} skipped")
      if [ ${#parts[@]} -gt 0 ]; then
        status_msg="${chkfile} ($(IFS=', '; echo "${parts[*]}"))"
      fi
    fi
    
    echo -e "${red}FAIL:${reset} ${status_msg}" >&2
    return 1
  fi
}

if (( ${#md5_files[@]} )); then
  if [ "${md5sum_missing:-0}" -eq 0 ]; then
    echo -e "${yellow}Processing:${reset} Verifying ${cyan}${#md5_files[@]}${reset} ${cyan}.md5${reset} file(s)..."
    for f in "${md5_files[@]}"; do
      if ! run_single_check md5sum "$f"; then
        rc=1
      fi
    done
  else
    echo -e "${red}Error:${reset} ${cyan}md5sum${reset} not available; skipping ${cyan}.md5${reset} checks." >&2
    rc=1
  fi
else
  echo -e "${yellow}Info:${reset} No .md5 files found."
fi

if (( ${#sha256_files[@]} )); then
  if [ "${sha256sum_missing:-0}" -eq 0 ]; then
    echo -e "${yellow}Processing:${reset} Verifying ${cyan}${#sha256_files[@]}${reset} ${cyan}.sha256${reset} file(s)..."
    for f in "${sha256_files[@]}"; do
      if ! run_single_check sha256sum "$f"; then
        rc=1
      fi
    done
  else
    echo -e "${red}Error:${reset} ${cyan}sha256sum${reset} not available; skipping ${cyan}.sha256${reset} checks." >&2
    rc=1
  fi
else
  echo -e "${yellow}Info:${reset} No .sha256 files found."
fi

if (( ${#sha512_files[@]} )); then
  if [ "${sha512sum_missing:-0}" -eq 0 ]; then
    echo -e "${yellow}Processing:${reset} Verifying ${cyan}${#sha512_files[@]}${reset} ${cyan}.sha512${reset} file(s)..."
    for f in "${sha512_files[@]}"; do
      if ! run_single_check sha512sum "$f"; then
        rc=1
      fi
    done
  else
    echo -e "${red}Error:${reset} ${cyan}sha512sum${reset} not available; skipping ${cyan}.sha512${reset} checks." >&2
    rc=1
  fi
else
  echo -e "${yellow}Info:${reset} No .sha512 files found."
fi

# Summary statistics
declare total_files=$((${#md5_files[@]} + ${#sha256_files[@]} + ${#sha512_files[@]}))
if [ $total_files -gt 0 ]; then
    echo ""
    if [ $rc -eq 0 ]; then
        echo -e "${green}✓ All $total_files checksum file(s) verified successfully${reset}"
    else
        echo -e "${red}✗ Some checksum verifications failed${reset}"
    fi
else
    echo -e "${yellow}No checksum files found to verify.${reset}"
fi

exit $rc