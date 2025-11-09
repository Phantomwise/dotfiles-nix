#!/usr/bin/env python3

import os
import csv
from colorama import Fore, Style, init

init(autoreset=True)

# AI Disclaimer: This script was generated with the assistance of an AI language model.

# Description:
    # Lists video files (movies/series) in a nested directory structure:
    # <Category>/<Type>/<Style>/<Collection>/<Source>/<Movie Folder>
    # Outputs CSV file with Category, Type, Style, Source, and other info.
    # Category can be only 'Films' or 'Series'.
    # Collection is parsed, but not in the CSV output.

def split_video(path):
    """
    Splits full video folder path:
      <Category>/<Type>/<Style>/<Collection>/<Source>/<Movie Folder>
    into:
      - Category
      - Type
      - Style
      - Collection
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
    parts = path.split(os.path.sep)
    if len(parts) < 6:
        print(f"{Fore.RED}Error:{Style.RESET_ALL} Path '{Fore.YELLOW}{path}{Style.RESET_ALL}' does not have enough levels (need at least 6)")
        raise ValueError(path)
    category, vtype, style, collection, source, remainder = parts[:6]
    # Step 1: extract year (first parenthetical) from remainder
    year_start = remainder.find('(')
    year_end = remainder.find(')')
    if year_start == -1 or year_end == -1 or year_end < year_start:
        print(f"{Fore.RED}Error:{Style.RESET_ALL} No year parenthetical in '{Fore.YELLOW}{remainder}{Style.RESET_ALL}'")
        raise ValueError(path)
    title = remainder[:year_start].strip()
    year = remainder[year_start+1:year_end].strip()
    remainder2 = remainder[year_end+1:].strip()
    # Step 2: extract first bracketed metadata [provider-id]
    if not remainder2.startswith('['):
        print(f"{Fore.RED}Error:{Style.RESET_ALL} No metadata bracket in '{Fore.YELLOW}{remainder2}{Style.RESET_ALL}'")
        raise ValueError(path)
    meta_end = remainder2.find(']')
    if meta_end == -1:
        print(f"{Fore.RED}Error:{Style.RESET_ALL} Unmatched '[' in '{Fore.YELLOW}{remainder2}{Style.RESET_ALL}'")
        raise ValueError(path)
    meta = remainder2[1:meta_end]
    remainder2 = remainder2[meta_end+1:].strip()
    if '-' not in meta:
        print(f"{Fore.RED}Error:{Style.RESET_ALL} Metadata malformed: '{Fore.CYAN}{meta}{Style.RESET_ALL}'")
        raise ValueError(path)
    metadata_provider, metadata_id = meta.split('-', 1)
    # Step 3: edition details after ' - ' (always present)
    if not remainder2.startswith('-'):
        print(f"{Fore.RED}Error:{Style.RESET_ALL} Expected '-' separator for edition in '{Fore.YELLOW}{remainder2}{Style.RESET_ALL}'")
        raise ValueError(path)
    remainder2 = remainder2[1:].strip()  # remove '-'
    paren_idx = remainder2.find('(')
    if paren_idx == -1:
        print(f"{Fore.RED}Error:{Style.RESET_ALL} No languages parenthesis found after edition in '{Fore.YELLOW}{remainder2}{Style.RESET_ALL}'")
        raise ValueError(path)
    edition_details = remainder2[:paren_idx].strip()  # may be empty
    remainder2 = remainder2[paren_idx:].strip()
    # Step 4: languages in parenthesis
    if not remainder2.startswith('('):
        print(f"{Fore.RED}Error:{Style.RESET_ALL} No languages parenthesis found in '{Fore.YELLOW}{remainder2}{Style.RESET_ALL}'")
        raise ValueError(path)
    lang_end = remainder2.find(')')
    if lang_end == -1:
        print(f"{Fore.RED}Error:{Style.RESET_ALL} Unmatched '(' in languages: '{Fore.YELLOW}{remainder2}{Style.RESET_ALL}'")
        raise ValueError(path)
    languages = remainder2[1:lang_end].strip()
    remainder2 = remainder2[lang_end+1:].strip()
    # Step 5: resolution in brackets (allowing multiple)
    resolutions = []
    while remainder2.startswith('['):
        res_end = remainder2.find(']')
        if res_end == -1:
            print(f"{Fore.RED}Error:{Style.RESET_ALL} Unmatched '[' in resolution: '{Fore.YELLOW}{remainder2}{Style.RESET_ALL}'")
            raise ValueError(path)
        resolutions.append(remainder2[1:res_end].strip())
        remainder2 = remainder2[res_end+1:].strip()
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
    if not remainder2.startswith('{'):
        print(f"{Fore.RED}Error:{Style.RESET_ALL} No source_details braces found in '{Fore.YELLOW}{remainder2}{Style.RESET_ALL}'")
        raise ValueError(path)
    src_end = remainder2.find('}')
    if src_end == -1:
        print(f"{Fore.RED}Error:{Style.RESET_ALL} Unmatched '{{' in source details: '{Fore.YELLOW}{remainder2}{Style.RESET_ALL}'")
        raise ValueError(path)
    source_details = remainder2[1:src_end].strip()
    # Step 6b: split SourceDetails into Src and Uploader
    details = [x.strip() for x in source_details.split(',')]
    Src = details[0] if len(details) >= 1 else ''
    uploader = details[1] if len(details) >= 2 else ''

    return {
        'Category': category,
        'Type': vtype,
        'Style': style,
        'Collection': collection,
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

# Traverse the nested structure to collect all <Movie Folder> paths
raw_rows = []
for category in os.listdir('.'):
    category_path = os.path.join('.', category)
    if not os.path.isdir(category_path) or category not in ['Films', 'Series']:
        continue
    for vtype in os.listdir(category_path):
        type_path = os.path.join(category_path, vtype)
        if not os.path.isdir(type_path):
            continue
        for style in os.listdir(type_path):
            style_path = os.path.join(type_path, style)
            if not os.path.isdir(style_path):
                continue
            for collection in os.listdir(style_path):
                collection_path = os.path.join(style_path, collection)
                if not os.path.isdir(collection_path):
                    continue
                for source in os.listdir(collection_path):
                    source_path = os.path.join(collection_path, source)
                    if not os.path.isdir(source_path):
                        continue
                    for moviefolder in os.listdir(source_path):
                        moviefolder_path = os.path.join(source_path, moviefolder)
                        if os.path.isdir(moviefolder_path):
                            rel_path = os.path.join(category, vtype, style, collection, source, moviefolder)
                            raw_rows.append({'FullPath': rel_path})

with open('videos-raw.csv', 'w', newline='', encoding='utf-8') as rawfile:
    writer = csv.DictWriter(rawfile, fieldnames=['FullPath'])
    writer.writeheader()
    writer.writerows(raw_rows)

# Parse and create formatted output, excluding 'Collection' from CSV
formatted_rows = []
with open('videos-raw.csv', newline='', encoding='utf-8') as rawfile:
    reader = csv.DictReader(rawfile)
    for row in reader:
        full_path = row['FullPath']
        try:
            parsed = split_video(full_path)
            formatted_rows.append(parsed)
        except ValueError:
            print(f"{Fore.RED}Skipping:{Style.RESET_ALL} '{full_path}' due to parsing error.")
            continue

fieldnames = [
    'Category', 'Type', 'Style',  # new fields, keep order
    'Source', 'Title', 'Year', 'MProv', 'MID', 'Edition',
    'Languages', 'Resolution', 'HR', 'VR', 'Src', 'Uploader'
    # 'Collection' field omitted
]
text_fields = {'Category', 'Type', 'Style', 'Source', 'Title', 'Edition', 'Languages', 'Resolution', 'Src', 'Uploader'}

with open('videos-formatted.csv', 'w', newline='', encoding='utf-8') as outfile:
    writer = csv.writer(outfile, quoting=csv.QUOTE_MINIMAL)
    writer.writerow(fieldnames)
    for row in formatted_rows:
        output_row = [row.get(field, '') for field in fieldnames]
        writer.writerow(output_row)