#!/usr/bin/env python3

import os
import csv

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
    - year (second-to-last parenthetical)
    - disc count and medium (last parenthetical)
    - tags: Label, Catalog, Barcode
    Raises ValueError if expected parentheticals are missing or malformed.
    """
    # Step 1: extract bracketed tags
    last_close = album.rfind(')')
    tags_part = ''
    if last_close != -1:
        tags_part = album[last_close+1:].strip()
        main_part = album[:last_close+1].strip()
    else:
        main_part = album

    # Extract tags from brackets
    tags = [tag.strip(' []') for tag in tags_part.split('[') if tag.strip()]
    while len(tags) < 3:
        tags.append('')  # fill missing tags with empty strings

    # Step 2: extract all parentheticals
    parens = []
    start = len(main_part)
    while True:
        close_idx = main_part.rfind(')', 0, start)
        if close_idx == -1:
            break
        open_idx = main_part.rfind('(', 0, close_idx)
        if open_idx == -1:
            break
        parens.insert(0, main_part[open_idx+1:close_idx].strip())
        start = open_idx

    # Step 3: enforce strict last-two-parentheticals rule
    if not parens:
        raise ValueError(f"Album '{album}' has no parentheticals; disc info is required.")
    disc_info = parens[-1]
    parts = disc_info.split(' ')
    if len(parts) != 2:
        raise ValueError(f"Disc info malformed: '{disc_info}' in album '{album}'")
    disc_count, medium = parts

    if len(parens) < 2:
        raise ValueError(f"Album '{album}' missing second-to-last parenthetical for year.")
    year = parens[-2]

    # Album title is everything before the second-to-last parenthetical
    title_end = main_part.rfind(f'({year})')
    album_title = main_part[:title_end].strip() if title_end != -1 else main_part

    return album_title, year, disc_count, medium, tags

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
        album_title, year, disc_count, medium, tags = split_album(album)
        formatted_rows.append({
            'Artist': row['Artist'],
            'AlbumTitle': album_title,
            'Year': year,
            'Nb': disc_count,
            'Medium': medium,
            'Label': tags[0],
            'Catalog': tags[1],
            'Barcode': tags[2]
        })

# Step 3: Write albums-formatted.csv with selective quoting
fieldnames = ['Artist', 'AlbumTitle', 'Year', 'Nb', 'Medium', 'Label', 'Catalog', 'Barcode']
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
