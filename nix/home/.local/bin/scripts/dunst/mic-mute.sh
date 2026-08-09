#!/usr/bin/env bash

# Check mic status using wpctl
mic_status=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)

# Parse the output to check if muted
if echo "$mic_status" | grep -q "\[MUTED\]"; then
    dunstify "Mic Muted" -u normal -r 109105099 -h "string:category:mic.mute"
else
    dunstify "Mic Unmuted" -u normal -r 109105099 -h "string:category:mic.unmute"
fi
