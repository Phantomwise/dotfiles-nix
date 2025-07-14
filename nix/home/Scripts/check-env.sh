#!/usr/bin/env bash

# Define color codes
declare -r red='\033[31m'
declare -r yellow='\033[33m'
declare -r green='\033[32m'
declare -r reset='\033[0m'

variables=(
	"USER"
	"SHELL"
	"WAYLAND_DISPLAY"
	"TEST_EMPTY"
	"TEST_UNSET"
)

TEST_EMPTY=""

for variable in "${variables[@]}"
	do
		# variable is not set
		if [ -z "${!variable+x}" ]; then
			status="(not set)"
			val=""
			color="$red"
		# variable is set but empty
		elif [ -z "${!variable}" ]; then
			status="(empty)"
			val=""
			color="$yellow"
		# variable is set and not empty
		else
			status="(set)"
			val="${!variable}"
			color="$green"
		fi
		printf "%-22s ${color}%-15s${reset} %s\n" "\$$variable" "$status" "$val"
	done
