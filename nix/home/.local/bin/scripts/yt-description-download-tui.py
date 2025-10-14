#!/usr/bin/env python3

# AI Disclaimer:
# This script was partially written by a LLM.

import os
import re
import requests
import json
import curses

# ANSI escape codes for colors
RED = '\033[91m'
GREEN = '\033[92m'
YELLOW = '\033[93m'
RESET = '\033[0m'

# ANSI escape codes for info messages
INFO="\033[1;33m[INFO]\033[0m"
SUCC="\033[1;32m[SUCCESS]\033[0m"
ERR="\033[1;31m[ERROR]\033[0m"

def select_from_list_tui(options, title="Select an option"):
	def tui(stdscr):
		curses.curs_set(0)
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
	matches = re.findall(r'\[([^\]]+)\]', filename)
	candidates = [m for m in matches if re.fullmatch(r'[a-zA-Z0-9_-]{11}', m)]
	if not candidates:
		return None
	if len(candidates) == 1:
		return candidates[0]
	title = f"Multiple possible video IDs found in:\n{filename}"
	return select_from_list_tui(candidates, title=title)

def download_description(video_id, save_path):
	url = f'https://www.youtube.com/watch?v={video_id}'
	try:
		r = requests.get(url)
		if r.status_code != 200:
			print(f'{ERR} Failed to fetch video page for ID: {video_id}')
			return
		# Extract JSON data containing video info
		m = re.search(r'var ytInitialPlayerResponse = ({.*?});', r.text)
		if not m:
			m = re.search(r'ytInitialPlayerResponse\s*=\s*({.*?});', r.text)
		if not m:
			print(f'{ERR} Could not find video metadata for ID: {video_id}')
			return
		data = json.loads(m.group(1))
		description = data.get('videoDetails', {}).get('shortDescription', '')
		if description:
			with open(save_path, 'w', encoding='utf-8') as f:
				f.write(description)
			print(f'{SUCC} Description saved for video ID: {video_id}')
		else:
			print(f'{INFO} No description found for video ID: {video_id}')
	except Exception as e:
		print(f'{ERR} Exception while fetching description for video ID: {video_id}: {e}')

def main():
	video_extensions = {'.mp4', '.mkv', '.webm', '.avi', '.mov'}
	current_directory = os.getcwd()
	for filename in os.listdir(current_directory):
		if os.path.splitext(filename)[1].lower() in video_extensions:
			video_id = extract_video_id(filename)
			if video_id:
				base_name = os.path.splitext(filename)[0]
				save_path = os.path.join(current_directory, f'{base_name}-description.txt')
				download_description(video_id, save_path)
			else:
				print(f'{ERR} No video ID found in filename: {filename}')

if __name__ == "__main__":
	main()
