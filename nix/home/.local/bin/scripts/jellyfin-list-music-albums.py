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
    - title
    - year
    - disc count and medium
    - label, catalog, barcode
    """
    # Step 1: extract bracketed tags
    last_close = album.rfind(')')
    tags_part = ''
    if last_close != -1:
        tags_part = album[last_close+1:].strip()
        main_part = album[:last_close+1].strip()
    else:
        main_part = album

    tags = [tag.strip(' []') for tag in tags_part.split('[') if tag.strip()]
    while len(tags) < 3:
        tags.append('')

    # Step 2: extract parenthetical parts (from end)
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

    # Step 3: determine album title, year, disc count/medium
    album_title = main_part
    year = ''
    disc_count = ''
    medium = ''
    if parens:
        # Check last two parentheses for year and disc info
        last_two = parens[-2:] if len(parens) >= 2 else parens
        for p in reversed(last_two):
            # Year: 4-digit number
            if not year and p.isdigit() and len(p) == 4:
                year = p
                album_title = main_part[:main_part.rfind(f'({p})')].strip()
            # Disc info: starts with digit
            elif not disc_count and (p[:2].isdigit() or (p[0].isdigit() and ' ' in p)):
                parts = p.split(' ', 1)
                disc_count = parts[0]
                medium = parts[1] if len(parts) > 1 else ''

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
