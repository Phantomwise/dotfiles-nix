#!/usr/bin/env bash

variables=(
	"USER"
	"SHELL"
	"WAYLAND_DISPLAY"
	"TESTTESTTEST"
)

for variable in "${variables[@]}"
	do
		# variable is not set
		if [ -z "${!variable+x}" ]; then
			status="(not set)"
			val=""
		# variable is set but empty
		elif [ -z "${!variable}" ]; then
			status="(empty)"
			val=""
		# variable is set and not empty
		else
			status="(set)"
			val="${!variable}"
		fi
		printf "%-22s %-15s %s\n" "\$$variable" "$status" "$val"
	done
