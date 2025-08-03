#!/usr/bin/env bash

# Define color codes
declare -r purple="\033[1;35m"
declare -r red="\033[1;31m"
declare -r yellow="\033[1;33m"
declare -r green="\033[1;32m"
declare -r reset="\033[0m"

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
		elif [ "${variable+x}" ]; then
			status="(set)"
			val="${!variable}"
			color="$green"
		# Variable is not set nor empty nor unset??? (just in case)
		else
			status="(unknown)"
			val=""
			color="$purple"
		fi
		# printf "%-22s ${color}%-15s${reset} %s\n" "\$$variable" "$status" "$val"
		printf "%-22s %b%-15s%b %s\n" "\$$variable" "$color" "$status" "$reset" "$val"
	done
