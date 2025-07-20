#!/usr/bin/env bash

options=("Option 1" "Option 2" "Option 3" "Quit")
selected=0

draw_menu() {
	clear
	echo "Use arrow keys to move; Enter to select."
	for i in "${!options[@]}"; do
		if [[ $i -eq $selected ]]; then
			# Highlight selected option
			echo -e "> \033[7m${options[$i]}\033[0m"
		else
			echo "  ${options[$i]}"
		fi
	done
}

while true; do
	draw_menu

	# Read single keypress (including arrow keys)
	IFS= read -rsn1 key  # read 1 char

	if [[ $key == $'\x1b' ]]; then
		# Escape sequence for arrow keys
		read -rsn2 -t 0.1 key2
		key+=$key2
	fi

	case "$key" in
		$'\x1b[A')  # Up arrow
			((selected--))
			if ((selected < 0)); then selected=$((${#options[@]} - 1)); fi
			;;
		$'\x1b[B')  # Down arrow
			((selected++))
			if ((selected >= ${#options[@]})); then selected=0; fi
			;;
		"")  # Enter key
			clear
			echo "You chose: ${options[$selected]}"
			break
			;;
	esac
done
