#!/usr/bin/env bash

# AI Disclaimer:
# This script was written with help from a LLM.

# Define ANSI color codes for different states
green='\033[0;32m'
red='\033[0;31m'
yellow='\033[0;33m'
reset='\033[0m' # No Color (reset)

# Function to return the state with the appropriate color
get_colored_state() {
    local state=$1
    case $state in
        running)
            echo -e "${green}$state${reset}"
            ;;
        degraded)
            echo -e "${red}$state${reset}"
            ;;
        maintenance)
            echo -e "${yellow}$state${reset}"
            ;;
        *)
            echo -e "${reset}$state${reset}"
            ;;
    esac
}

# Check if the system is using systemd
if [ ! -d /run/systemd/system ]; then
    echo -e "${red}Error: This system does not appear to be using systemd.${reset}"
    exit 1
fi

# Retrieve and print the overall system state from systemctl status
if system_state=$(systemctl status | grep -m 1 "State:" | awk '{print $2}'); then
    echo -e "System State: $(get_colored_state "$system_state")"
    if [ "$system_state" = "degraded" ]; then
        echo -e "${red}System has degraded services:${reset}"
        systemctl --failed
    fi
else
    echo -e "System State: ${red}Error retrieving state${reset}"
fi

# Retrieve and print the overall user service state from systemctl --user status
if user_state=$(systemctl --user status | grep -m 1 "State:" | awk '{print $2}'); then
    echo -e "User State: $(get_colored_state "$user_state")"
    if [ "$user_state" = "degraded" ]; then
        echo -e "${red}User services have degraded services:${reset}"
        systemctl --user --failed
    fi
else
    echo -e "User State: ${red}Error retrieving state${reset}"
fi