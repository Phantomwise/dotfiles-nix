#!/usr/bin/env python3

import os
import csv
from colorama import Fore, Style, init

init(autoreset=True)

# AI Disclaimer: This script was generated with the assistance of an AI language model.

# Description:
    # Lists music albums in the current directory
    # Outputs CSV file

# Usage:
    # Run the script in the directory to be scanned to produce the CSV file
    # Run `open albums-formatted.csv` in nushell to view the results

# Supported folders names:
    # - Artist/Album Title (Year) (Disc Count Medium) [Label] [Catalog] [Barcode]
    # - Album Title (Year) (Disc Count Medium) [Label] [Catalog] [Barcode]

# TODO: Rewrite without AI when I have time
# TODO: Maybe remove the intermediate albums-raw.csv file? It was needed during debugging but now it works so I guess it's not needed anymore.

def split_album(album):
    """
    Splits album folder name into:
    - album title
    - original_year (second-to-last parenthetical)
    - disc count and medium (last parenthetical)
    - issue_year (first bracketed)
    - label, catalog, barcode (next brackets)
    Raises ValueError if any expected parenthetical or bracket is missing.
    """
    # Step 1: extract all parentheticals
    parens = []
    start = len(album)
    while True:
        close_idx = album.rfind(')', 0, start)
        if close_idx == -1:
            break
        open_idx = album.rfind('(', 0, close_idx)
        if open_idx == -1:
            break
        parens.insert(0, album[open_idx+1:close_idx].strip())
        start = open_idx

    if len(parens) < 2:
        print(f"{Fore.RED}Error:{Style.RESET_ALL} No parentheticals found in album '{Fore.YELLOW}{album}{Style.RESET_ALL}'; disc info and year are required.")
        raise ValueError(album)

    original_year = parens[-2]
    disc_info = parens[-1]

    # parse disc count and medium
    parts = disc_info.split(' ')
    if len(parts) != 2:
        print(f"{Fore.RED}Error:{Style.RESET_ALL} Disc info malformed in album '{Fore.YELLOW}{album}{Style.RESET_ALL}': '{Fore.CYAN}{disc_info}{Style.RESET_ALL}'")
        raise ValueError(album)
    disc_count, medium = parts

    # Album title is everything before the second-to-last parenthetical
    title_end = album.rfind(f'({original_year})')
    album_title = album[:title_end].strip() if title_end != -1 else album

    # Step 2: extract bracketed values strictly in order
    brackets = []
    remainder = album[title_end + len(f'({original_year})') + len(f'({disc_info})'):]  # rest after last two parentheses
    idx = 0
    while idx < len(remainder):
        if remainder[idx] == '[':
            close_idx = remainder.find(']', idx)
            if close_idx == -1:
                print(f"{Fore.RED}Error:{Style.RESET_ALL} Unmatched '[' in album '{Fore.YELLOW}{album}{Style.RESET_ALL}'")
                raise ValueError(album)
            brackets.append(remainder[idx+1:close_idx].strip())
            idx = close_idx + 1
        else:
            idx += 1

    if len(brackets) < 4:
        print(f"{Fore.RED}Error:{Style.RESET_ALL} Album '{Fore.YELLOW}{album}{Style.RESET_ALL}' must have 4 bracketed values: [issue_year] [label] [catalog] [barcode]")
        raise ValueError(album)

    issue_year, label, catalog, barcode = brackets[:4]

    return album_title, original_year, disc_count, medium, issue_year, label, catalog, barcode

# Step 1: Detect if folders are Artist/Album or just Album
all_items = [d for d in os.listdir('.') if os.path.isdir(d)]
album_only_mode = True
for item in all_items:
    subfolders = [sf for sf in os.listdir(item) if os.path.isdir(os.path.join(item, sf))]
    if subfolders:
        album_only_mode = False
        break

raw_rows = []
if album_only_mode:
    for album in all_items:
        raw_rows.append({'Artist': 'None', 'Album': album})
else:
    for artist in all_items:
        artist_path = os.path.join('.', artist)
        if os.path.isdir(artist_path):
            album_dirs = [a for a in os.listdir(artist_path) if os.path.isdir(os.path.join(artist_path, a))]
            for album in album_dirs:
                raw_rows.append({'Artist': artist, 'Album': album})

with open('albums-raw.csv', 'w', newline='', encoding='utf-8') as rawfile:
    writer = csv.DictWriter(rawfile, fieldnames=['Artist', 'Album'])
    writer.writeheader()
    writer.writerows(raw_rows)

# Step 2: Parse and create albums-formatted.csv
formatted_rows = []
with open('albums-raw.csv', newline='', encoding='utf-8') as rawfile:
    reader = csv.DictReader(rawfile)
    for row in reader:
        album = row['Album']
        (album_title, original_year, disc_count, medium,
         issue_year, label, catalog, barcode) = split_album(album)
        formatted_rows.append({
            'Artist': row['Artist'],
            'AlbumTitle': album_title,
            'O Year': original_year,
            'Nb': disc_count,
            'Medium': medium,
            'I Year': issue_year,
            'Label': label,
            'Catalog': catalog,
            'Barcode': barcode
        })

# Step 3: Write albums-formatted.csv with selective quoting
fieldnames = ['Artist', 'AlbumTitle', 'O Year', 'Nb', 'Medium', 'I Year', 'Label', 'Catalog', 'Barcode']
text_fields = {'Artist', 'AlbumTitle', 'Barcode'}

with open('albums-formatted.csv', 'w', newline='', encoding='utf-8') as outfile:
    writer = csv.writer(outfile, quoting=csv.QUOTE_MINIMAL)
    writer.writerow(fieldnames)

    for row in formatted_rows:
        output_row = []
        for field in fieldnames:
            value = row.get(field, '')
            if field in text_fields:
                # Escape internal quotes and always quote
                value = str(value).replace('"', '""')
                value = f'"{value}"'
            output_row.append(value)
        outfile.write(','.join(str(v) for v in output_row) + '\n')
