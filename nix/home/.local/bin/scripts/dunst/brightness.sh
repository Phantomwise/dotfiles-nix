#!/usr/bin/env bash

# Get the current brightness percentage
BRIGHTNESS_PERCENTAGE=$(brightnessctl | grep -oP '\(\K[0-9]+(?=%)')

# Debugging output
echo "Brightness Percentage: $BRIGHTNESS_PERCENTAGE"

# Send the notification with a progress bar and custom highlight color
dunstify "Brightness" "Brightness Level: $BRIGHTNESS_PERCENTAGE%" -u normal -r 98114105 -h "int:value:$BRIGHTNESS_PERCENTAGE" -h "string:hlcolor:#FFFFFF" -h "string:category:brightness"
