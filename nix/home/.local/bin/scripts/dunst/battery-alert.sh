#!/usr/bin/env bash

# AI Disclaimer:
# This script was written with help from a LLM.

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

warning_level=25
critical_level=10

# Extract battery status
battery_discharging=$(acpi -b | grep "Battery 0" | grep -c "Discharging")
battery_level=$(acpi -b | grep "Battery 0" | grep -P -o '[0-9]+(?=%)')

full_file=/tmp/batteryfull
low_file=/tmp/batterylow
critical_file=/tmp/batterycritical

# Remove existing notifications if battery is charging
if [ "$battery_discharging" -eq 0 ] && [ -f $full_file ]; then
    rm $full_file
elif [ "$battery_discharging" -eq 1 ] && [ -f $low_file ]; then
    rm $low_file
fi

# Check battery levels and send notifications
if [ -n "$battery_level" ]; then
    if [ "$battery_level" -le $critical_level ] && [ "$battery_discharging" -eq 1 ]; then
        dunstify "Battery Critical" "The computer will shutdown soon." -u critical -r 9991 -h int:value:"${battery_level}" -h "string:hlcolor:#FFFFFF" -h "string:category:battery.critical"
        touch $critical_file
    elif [ "$battery_level" -le $warning_level ] && [ "$battery_discharging" -eq 1 ] && [ ! -f $low_file ]; then
        dunstify "Low Battery" "${battery_level}% of battery remaining." -u normal -r 9991 -h int:value:"${battery_level}" -h "string:hlcolor:#FFFFFF" -h "string:category:battery.low"
        touch $low_file
    elif [ "$battery_level" -gt 99 ] && [ "$battery_discharging" -eq 0 ] && [ ! -f $full_file ]; then
        dunstify "Battery Charged" "Battery is fully charged." -u normal -r 9991 -h int:value:"${battery_level}" -h "string:hlcolor:#FFFFFF" -h "string:category:battery.full"
        touch $full_file
    fi
fi
