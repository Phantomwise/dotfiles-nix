#!/usr/bin/env bash

while true; do
    ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1 && notify-send "Yay internet is back \o/"
    sleep 15
done
