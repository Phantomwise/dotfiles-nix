#!/usr/bin/env python3

# AI Disclaimer:
# This script was written by Github Copilot.

import os
import re
import requests

# ANSI escape codes for colors
RED = '\033[91m'
GREEN = '\033[92m'
YELLOW = '\033[93m'
RESET = '\033[0m'

# Info messages formatting
INFO="\033[1;33m[INFO]\033[0m"
SUCC="\033[1;32m[SUCCESS]\033[0m"
ERR="\033[1;31m[ERROR]\033[0m"

def extract_video_id(filename):
	"""
	Extract the YouTube video ID from a filename with multiple bracketed tags.
	If multiple candidates are found, ask the user to pick one.
	"""
	matches = re.findall(r'\[([^\]]+)\]', filename)
	# Filter to candidates that match YouTube ID pattern (11 chars, letters/numbers/_/-)
	candidates = [m for m in matches if re.fullmatch(r'[a-zA-Z0-9_-]{11}', m)]

	if not candidates:
		return None

	if len(candidates) == 1:
		return candidates[0]

	# Multiple candidates found: ask user
	print(f"{INFO} Multiple possible video IDs found in '{filename}':")
	for i, candidate in enumerate(candidates, start=1):
		print(f"  {i}: {candidate}")
	
	while True:
		choice = input(f"Pick the correct video ID (1-{len(candidates)}): ")
		if choice.isdigit():
			index = int(choice) - 1
			if 0 <= index < len(candidates):
				return candidates[index]
		print(f"{ERR} Invalid choice, please try again.")

def download_thumbnail(video_id, save_path):
	# List of possible thumbnail resolutions, from highest to lowest
	resolutions = ['maxresdefault.jpg', 'hqdefault.jpg', 'mqdefault.jpg', 'sddefault.jpg', 'default.jpg']
	for resolution in resolutions:
		# Construct the URL for the thumbnail
		url = f'https://img.youtube.com/vi/{video_id}/{resolution}'
		try:
			# Send a GET request to the URL
			response = requests.get(url)
			if response.status_code == 200:
				# If the response is successful, save the thumbnail to the specified path
				with open(save_path, 'wb') as file:
					file.write(response.content)
				print(f'{SUCC} Thumbnail downloaded for video ID: {video_id} at resolution: {resolution}')
				return
			else:
				# If the response is not successful, print an error message with the status code
				print(f'{INFO} Failed to download thumbnail for video ID: {video_id} at resolution: {resolution}, HTTP status code: {response.status_code}')
		except requests.exceptions.RequestException as e:
			# If there is a network-related error, print an exception message
			print(f'{ERR} Exception occurred while downloading thumbnail for video ID: {video_id} at resolution: {resolution}, Exception: {e}')
	# If all attempts fail, print a message indicating that all attempts failed
	print(f'{ERR} All attempts failed for video ID: {video_id}')

def main():
	# Set of video file extensions to look for
	video_extensions = {'.mp4', '.mkv', '.webm', '.avi', '.mov'}
	# Get the current working directory
	current_directory = os.getcwd()
	# Iterate over all files in the current directory
	for filename in os.listdir(current_directory):
		# Check if the file has a video extension
		if os.path.splitext(filename)[1].lower() in video_extensions:
			# Extract the video ID from the filename
			video_id = extract_video_id(filename)
			if video_id:
				# Construct the path to save the thumbnail with '-poster' appended to the original filename
				base_name = os.path.splitext(filename)[0]
				save_path = os.path.join(current_directory, f'{base_name}-poster.jpg')
				# Attempt to download the thumbnail
				download_thumbnail(video_id, save_path)
			else:
				# If no video ID is found in the filename, print a message
				print(f'{ERR} No video ID found in filename: {filename}')

if __name__ == "__main__":
	# Entry point of the script
	main()