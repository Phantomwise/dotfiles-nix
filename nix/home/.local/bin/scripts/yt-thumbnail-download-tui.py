#!/usr/bin/env python3

# AI Disclaimer:
# This script was written by a LLM.

import os
import re
import requests
import curses

# ANSI escape codes for colors
RED = '\033[91m'
GREEN = '\033[92m'
YELLOW = '\033[93m'
RESET = '\033[0m'

# Info messages formatting
INFO="\033[1;33m[INFO]\033[0m"
SUCC="\033[1;32m[SUCCESS]\033[0m"
ERR="\033[1;31m[ERROR]\033[0m"

def select_from_list_tui(options, title="Select an option"):
	"""
	Display a simple curses TUI to select an option from a list.
	Use arrow keys and Enter.
	Returns the selected option.
	"""
	def tui(stdscr):
		curses.curs_set(0)  # hide cursor
		index = 0
		while True:
			stdscr.clear()
			stdscr.addstr(0, 0, title, curses.A_BOLD)
			for i, option in enumerate(options):
				if i == index:
					stdscr.addstr(i + 2, 2, f"> {option}", curses.A_REVERSE)
				else:
					stdscr.addstr(i + 2, 2, f"  {option}")
			key = stdscr.getch()
			if key in (curses.KEY_UP, ord('k')):
				index = (index - 1) % len(options)
			elif key in (curses.KEY_DOWN, ord('j')):
				index = (index + 1) % len(options)
			elif key in (curses.KEY_ENTER, ord('\n'), ord('\r')):
				return options[index]

	return curses.wrapper(tui)

def extract_video_id(filename):
	"""
	Extract the YouTube video ID from a filename with multiple bracketed tags.
	If multiple candidates are found, show a curses TUI menu to pick one.
	"""
	matches = re.findall(r'\[([^\]]+)\]', filename)
	# Filter to candidates that match YouTube ID pattern (11 chars, letters/numbers/_/-)
	candidates = [m for m in matches if re.fullmatch(r'[a-zA-Z0-9_-]{11}', m)]

	if not candidates:
		return None

	if len(candidates) == 1:
		return candidates[0]

	# Multiple candidates: use TUI
	title = f"Multiple possible video IDs found in:\n{filename}"
	return select_from_list_tui(candidates, title=title)

def download_thumbnail(video_id, save_path):
	# List of possible thumbnail resolutions, from highest to lowest
	resolutions = ['maxresdefault.jpg', 'hqdefault.jpg', 'mqdefault.jpg', 'sddefault.jpg', 'default.jpg']
	for resolution in resolutions:
		url = f'https://img.youtube.com/vi/{video_id}/{resolution}'
		try:
			response = requests.get(url)
			if response.status_code == 200:
				with open(save_path, 'wb') as file:
					file.write(response.content)
				print(f'{SUCC} Thumbnail downloaded for video ID: {video_id} at resolution: {resolution}')
				return
			else:
				print(f'{INFO} Failed to download thumbnail for video ID: {video_id} at resolution: {resolution}, HTTP status code: {response.status_code}')
		except requests.exceptions.RequestException as e:
			print(f'{ERR} Exception occurred while downloading thumbnail for video ID: {video_id} at resolution: {resolution}, Exception: {e}')
	print(f'{ERR} All attempts failed for video ID: {video_id}')

def main():
	video_extensions = {'.mp4', '.mkv', '.webm', '.avi', '.mov'}
	current_directory = os.getcwd()
	for filename in os.listdir(current_directory):
		if os.path.splitext(filename)[1].lower() in video_extensions:
			video_id = extract_video_id(filename)
			if video_id:
				base_name = os.path.splitext(filename)[0]
				save_path = os.path.join(current_directory, f'{base_name}-poster.jpg')
				download_thumbnail(video_id, save_path)
			else:
				print(f'{ERR} No video ID found in filename: {filename}')

if __name__ == "__main__":
	main()
