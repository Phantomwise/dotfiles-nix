#!/usr/bin/env bash

# Get the current volume percentage
VOLUME_OUTPUT=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
VOLUME_PERCENTAGE=$(echo "$VOLUME_OUTPUT" | grep -oP '\d+(\.\d+)?' | awk '{print int($1 * 100)}')

# Debugging output
echo "Volume Percentage: $VOLUME_PERCENTAGE"

# Send the notification with a progress bar and custom highlight color
dunstify "Volume" "Volume Level: $VOLUME_PERCENTAGE%" -u normal -r 118111108 -h "int:value:$VOLUME_PERCENTAGE" -h "string:hlcolor:#FFFFFF" -h "string:category:volume.change"
