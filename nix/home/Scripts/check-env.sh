#!/usr/bin/env bash

# Define color codes
declare -r purple="\033[1;35m"
declare -r red="\033[1;31m"
declare -r yellow="\033[1;33m"
declare -r green="\033[1;32m"
declare -r reset="\033[0m"

variables=(
	"BASH_SOURCE"
	"BASH_VERSION"
	"COLORTERM"
	"DBUS_SESSION_BUS_ADDRESS"
	"DISPLAY"
	"EDITOR"
	"HOME"
	"HOST"
	"HOSTNAME"
	"LOGNAME"
	"PAGER"
	"PATH"
	"UID"
	"USER"
	"SHELL"
	"SHLVL"
	"TERM"
	"VISUAL"
	"WAYLAND_DISPLAY"
	"XDG_CACHE_HOME"
	"XDG_CONFIG_DIRS"
	"XDG_CONFIG_HOME"
	"XDG_CURRENT_DESKTOP"
	"XDG_DATA_DIRS"
	"XDG_DATA_HOME"
	"XDG_RUNTIME_DIR"
	"XDG_SEAT"
	"XDG_SESSION_CLASS"
	"XDG_SESSION_ID"
	"XDG_SESSION_TYPE"
	"XDG_SESSION_DESKTOP"
	"XDG_STATE_HOME"
	"XDG_VTNR"
	"ZDOTDIR"
	"TEST_SET"
	"TEST_EMPTY"
	"TEST_UNSET"
)

# Define test variables
TEST_SET="Test set variable"
TEST_EMPTY=""

for variable in "${variables[@]}"
	do
		# Variable is not set
		if [ -z "${!variable+x}" ]; then
			status="(not set)"
			val=""
			color="$red"
		# Variable is set but empty
		elif [ -z "${!variable}" ]; then
			status="(empty)"
			val=""
			color="$yellow"
		# Variable is set and not empty
		elif [ -n "${!variable}" ]; then
			status="(set)"
			val="${!variable}"
			color="$green"
		# Variable is not set nor empty nor unset (should never be true, hopefully)
		else
			status="(unknown)"
			val=""
			color="$purple"
		fi
		# printf "%-22s ${color}%-15s${reset} %s\n" "\$$variable" "$status" "$val"
		printf "%-27s %b%-15s%b %s\n" "\$$variable" "$color" "$status" "$reset" "$val"
	done
