#!/usr/bin/env bash

# AI Disclaimer:
# This script was written with help from a LLM.

# Define colors
green='\033[0;32m'
red='\033[0;31m'
yellow='\033[0;33m'
reset='\033[0m'

# Function to get colored state
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

# System status
echo -e "System Check"
echo -e "├── Systemd"
echo -e "│   ├── System State:"
if system_state=$(systemctl show --property=SystemState --value); then
    echo -e "│   │   └── $(get_colored_state "$system_state")"
    if [ "$system_state" = "degraded" ]; then
        echo -e "│   │       ${red}System has degraded services:${reset}"
        systemctl --failed
    fi
else
    echo -e "│   │   └── ${red}Error retrieving state${reset}"
fi

echo -e "│   ├── User State:"
if user_state=$(systemctl --user show --property=SystemState --value
); then
    echo -e "│   │   └── $(get_colored_state "$user_state")"
    if [ "$user_state" = "degraded" ]; then
        echo -e "│   │       ${red}User services have degraded services:${reset}"
        systemctl --user --failed
    fi
else
    echo -e "│   │   └── ${red}Error retrieving state${reset}"
fi

echo -e "├── Polkit"
echo -e "│   ├── Polkit Service:"
if systemctl is-active --quiet polkit; then
    echo -e "│   │   └── ${green}Active${reset}"
else
    echo -e "│   │   └── ${red}Inactive${reset}"
fi

echo -e "│   ├── Polkit Authentication Agents:"
agents=("polkit-gnome-authentication-agent-1" "lxpolkit" "mate-polkit" "xfce-polkit" "kde-polkit" "polkit-kde-authentication-agent-1")
agent_found=false

for agent in "${agents[@]}"; do
    if pgrep -x "$agent" > /dev/null 2>&1; then
        echo -e "│   │   └── ${green}$agent${reset} is running"
        agent_found=true
    fi
done

if [ "$agent_found" = false ]; then
    echo -e "│   │   └── ${red}No polkit authentication agent is running${reset}"
fi

echo -e "├── Wayland Portals"
echo -e "│   ├── Running Wayland Portals:"
wayland_portals=$(systemctl --user list-units --type=service | grep portal | awk '{print $1}')
if [ -n "$wayland_portals" ]; then
    IFS=$'\n' read -rd '' -a portals <<<"$wayland_portals"
    for i in "${!portals[@]}"; do
        if [ "$i" -eq $((${#portals[@]} - 1)) ]; then
            echo -e "│   │   └── ${green}${portals[$i]}${reset}"
        else
            echo -e "│   │   ├── ${green}${portals[$i]}${reset}"
        fi
    done
else
    echo -e "│   │   └── ${red}No Wayland portals running${reset}"
fi