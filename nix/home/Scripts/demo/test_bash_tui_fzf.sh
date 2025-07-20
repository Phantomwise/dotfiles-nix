#!/usr/bin/env bash

options=("Option 1" "Option 2" "Option 3")
selected=$(printf '%s\n' "${options[@]}" | fzf --height=5 --border --prompt="Choose: ")
echo "You selected: $selected"
