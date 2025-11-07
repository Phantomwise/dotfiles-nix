#!/usr/bin/env python3

import os
import csv
from colorama import Fore, Style, init

init(autoreset=True)

# AI Disclaimer: This script was generated with the assistance of an AI language model.

# Description:
# Lists video files (movies/series) in the current directory
# Outputs CSV file with HR/VR and Src/Uploader fields

def split_video(path):
    """
    Splits video folder name into:
    - Source
    - Title
    - Year
    - MProv (Metadata Provider)
    - MID (Metadata ID)
    - Edition (may be empty)
    - Languages
    - Resolution
    - HR (Horizontal Resolution)
    - VR (Vertical Resolution)
    - Src
    - Uploader
    """
    # Step 0: separate source if present
    if os.path.sep in path:
        source, remainder = path.split(os.path.sep, 1)
    else:
        source = 'None'
        remainder = path

    # Step 1: extract year (first parenthetical)
    year_start = remainder.find('(')
    year_end = remainder.find(')')
    if year_start == -1 or year_end == -1 or year_end < year_start:
        print(f"{Fore.RED}Error:{Style.RESET_ALL} No year parenthetical in '{Fore.YELLOW}{remainder}{Style.RESET_ALL}'")
        raise ValueError(path)
    title = remainder[:year_start].strip()
    year = remainder[year_start+1:year_end].strip()
    remainder = remainder[year_end+1:].strip()

    # Step 2: extract first bracketed metadata [provider-id]
    if not remainder.startswith('['):
        print(f"{Fore.RED}Error:{Style.RESET_ALL} No metadata bracket in '{Fore.YELLOW}{remainder}{Style.RESET_ALL}'")
        raise ValueError(path)
    meta_end = remainder.find(']')
    if meta_end == -1:
        print(f"{Fore.RED}Error:{Style.RESET_ALL} Unmatched '[' in '{Fore.YELLOW}{remainder}{Style.RESET_ALL}'")
        raise ValueError(path)
    meta = remainder[1:meta_end]
    remainder = remainder[meta_end+1:].strip()
    if '-' not in meta:
        print(f"{Fore.RED}Error:{Style.RESET_ALL} Metadata malformed: '{Fore.CYAN}{meta}{Style.RESET_ALL}'")
        raise ValueError(path)
    metadata_provider, metadata_id = meta.split('-', 1)

    # Step 3: edition details after ' - ' (always present)
    if not remainder.startswith('-'):
        print(f"{Fore.RED}Error:{Style.RESET_ALL} Expected '-' separator for edition in '{Fore.YELLOW}{remainder}{Style.RESET_ALL}'")
        raise ValueError(path)
    remainder = remainder[1:].strip()  # remove '-'
    paren_idx = remainder.find('(')
    if paren_idx == -1:
        print(f"{Fore.RED}Error:{Style.RESET_ALL} No languages parenthesis found after edition in '{Fore.YELLOW}{remainder}{Style.RESET_ALL}'")
        raise ValueError(path)
    edition_details = remainder[:paren_idx].strip()  # may be empty
    remainder = remainder[paren_idx:].strip()

    # Step 4: languages in parenthesis
    if not remainder.startswith('('):
        print(f"{Fore.RED}Error:{Style.RESET_ALL} No languages parenthesis found in '{Fore.YELLOW}{remainder}{Style.RESET_ALL}'")
        raise ValueError(path)
    lang_end = remainder.find(')')
    if lang_end == -1:
        print(f"{Fore.RED}Error:{Style.RESET_ALL} Unmatched '(' in languages: '{Fore.YELLOW}{remainder}{Style.RESET_ALL}'")
        raise ValueError(path)
    languages = remainder[1:lang_end].strip()
    remainder = remainder[lang_end+1:].strip()

    # Step 5: resolution in brackets (allowing multiple)
    resolutions = []
    while remainder.startswith('['):
        res_end = remainder.find(']')
        if res_end == -1:
            print(f"{Fore.RED}Error:{Style.RESET_ALL} Unmatched '[' in resolution: '{Fore.YELLOW}{remainder}{Style.RESET_ALL}'")
            raise ValueError(path)
        resolutions.append(remainder[1:res_end].strip())
        remainder = remainder[res_end+1:].strip()

    # Join multiple resolutions with 'x' for Resolution field
    resolution = 'x'.join(resolutions)

    # Step 5b: determine VR and HR
    if 'x' not in resolution:
        print(f"{Fore.RED}Error:{Style.RESET_ALL} Resolution '{Fore.YELLOW}{resolution}{Style.RESET_ALL}' does not contain 'x'")
        raise ValueError(path)
    elif resolution.count('x') == 1:
        hr, vr = resolution.split('x')
    else:
        hr = vr = 'Unknown'

    # Step 6: source_details in curly braces
    if not remainder.startswith('{'):
        print(f"{Fore.RED}Error:{Style.RESET_ALL} No source_details braces found in '{Fore.YELLOW}{remainder}{Style.RESET_ALL}'")
        raise ValueError(path)
    src_end = remainder.find('}')
    if src_end == -1:
        print(f"{Fore.RED}Error:{Style.RESET_ALL} Unmatched '{{' in source details: '{Fore.YELLOW}{remainder}{Style.RESET_ALL}'")
        raise ValueError(path)
    source_details = remainder[1:src_end].strip()

    # Step 6b: split SourceDetails into Src and Uploader
    details = [x.strip() for x in source_details.split(',')]
    Src = details[0] if len(details) >= 1 else ''
    uploader = details[1] if len(details) >= 2 else ''

    return {
        'Source': source,
        'Title': title,
        'Year': year,
        'MProv': metadata_provider,
        'MID': metadata_id,
        'Edition': edition_details,
        'Languages': languages,
        'Resolution': resolution,
        'HR': hr,
        'VR': vr,
        'Src': Src,
        'Uploader': uploader
    }

# Step 1: Detect if folders are Source/Title or just Title
all_items = [d for d in os.listdir('.') if os.path.isdir(d)]
title_only_mode = True
for item in all_items:
    subfolders = [sf for sf in os.listdir(item) if os.path.isdir(os.path.join(item, sf))]
    if subfolders:
        title_only_mode = False
        break

raw_rows = []
if title_only_mode:
    for title in all_items:
        raw_rows.append({'Source': 'None', 'TitlePath': title})
else:
    for source in all_items:
        source_path = os.path.join('.', source)
        if os.path.isdir(source_path):
            title_dirs = [t for t in os.listdir(source_path) if os.path.isdir(os.path.join(source_path, t))]
            for title in title_dirs:
                raw_rows.append({'Source': source, 'TitlePath': title})

with open('videos-raw.csv', 'w', newline='', encoding='utf-8') as rawfile:
    writer = csv.DictWriter(rawfile, fieldnames=['Source', 'TitlePath'])
    writer.writeheader()
    writer.writerows(raw_rows)

# Step 2: Parse and create videos-formatted.csv
formatted_rows = []
with open('videos-raw.csv', newline='', encoding='utf-8') as rawfile:
    reader = csv.DictReader(rawfile)
    for row in reader:
        title_path = row['TitlePath']
        try:
            parsed = split_video(os.path.join(row['Source'], title_path) if row['Source'] != 'None' else title_path)
            formatted_rows.append(parsed)
        except ValueError:
            print(f"{Fore.RED}Skipping:{Style.RESET_ALL} '{title_path}' due to parsing error.")
            continue

# Step 3: Write videos-formatted.csv with selective quoting
fieldnames = ['Source', 'Title', 'Year', 'MProv', 'MID', 'Edition',
              'Languages', 'Resolution', 'HR', 'VR', 'Src', 'Uploader']
text_fields = {'Source', 'Title', 'Edition', 'Languages', 'Resolution', 'Src', 'Uploader'}

with open('videos-formatted.csv', 'w', newline='', encoding='utf-8') as outfile:
    writer = csv.writer(outfile, quoting=csv.QUOTE_MINIMAL)
    writer.writerow(fieldnames)

    for row in formatted_rows:
        output_row = [row.get(field, '') for field in fieldnames]
        writer.writerow(output_row)  # <- inside the 'with' block
