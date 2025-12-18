#!/usr/bin/env python3

import os
import csv
import sys
from colorama import Fore, Style, init

init(autoreset=True)

# AI Disclaimer: This script was generated with the assistance of an AI language model.

# Description:
#   Lists video files (movies/series) in a nested directory structure:
#   <Category>/<Type>/<Style>/<Source>/<Movie Folder>
#   Outputs CSV file with Category, Type, Style, Source, and other info.
#   Category can be only 'Films' or 'Series'.
#   Previously there was a 'Collection' layer; this script has been updated to remove it.

def split_video(path):
    """
    Splits full video folder path:
      <Category>/<Type>/<Style>/<Source>/<Movie Folder>
    into:
      - Category
      - Type
      - Style
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
    if len(parts) < 5:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Path '{Fore.BLUE}{path}{Style.RESET_ALL}' does not have enough levels (need at least 5)")
        raise ValueError("Not enough levels")
    category, vtype, style, source, remainder = parts[:5]
    year_start = remainder.find('(')
    year_end = remainder.find(')')
    if year_start == -1 or year_end == -1 or year_end < year_start:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} No year parenthetical in '{Fore.BLUE}{remainder}{Style.RESET_ALL}'")
        raise ValueError("No year parenthetical")
    title = remainder[:year_start].strip()
    year = remainder[year_start+1:year_end].strip()
    remainder2 = remainder[year_end+1:].strip()
    if not remainder2.startswith('['):
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} No metadata bracket in '{Fore.BLUE}{remainder2}{Style.RESET_ALL}'")
        raise ValueError("No metadata bracket")
    meta_end = remainder2.find(']')
    if meta_end == -1:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Unmatched '[' in '{Fore.BLUE}{remainder2}{Style.RESET_ALL}'")
        raise ValueError("Unmatched '[' in metadata")
    meta = remainder2[1:meta_end]
    remainder2 = remainder2[meta_end+1:].strip()
    if '-' not in meta:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Metadata malformed: '{Fore.MAGENTA}{meta}{Style.RESET_ALL}'")
        raise ValueError("Metadata malformed")
    metadata_provider, metadata_id = meta.split('-', 1)
    if not remainder2.startswith('-'):
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Expected '-' separator for edition in '{Fore.BLUE}{remainder2}{Style.RESET_ALL}'")
        raise ValueError("Expected '-' for edition")
    remainder2 = remainder2[1:].strip()
    paren_idx = remainder2.find('(')
    if paren_idx == -1:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} No languages parenthesis found after edition in '{Fore.BLUE}{remainder2}{Style.RESET_ALL}'")
        raise ValueError("No languages parenthesis after edition")
    edition_details = remainder2[:paren_idx].strip()
    remainder2 = remainder2[paren_idx:].strip()
    if not remainder2.startswith('('):
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} No languages parenthesis found in '{Fore.BLUE}{remainder2}{Style.RESET_ALL}'")
        raise ValueError("No languages parenthesis")
    lang_end = remainder2.find(')')
    if lang_end == -1:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Unmatched '(' in languages: '{Fore.BLUE}{remainder2}{Style.RESET_ALL}'")
        raise ValueError("Unmatched '(' in languages")
    languages = remainder2[1:lang_end].strip()
    remainder2 = remainder2[lang_end+1:].strip()
    resolutions = []
    while remainder2.startswith('['):
        res_end = remainder2.find(']')
        if res_end == -1:
            print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Unmatched '[' in resolution: '{Fore.BLUE}{remainder2}{Style.RESET_ALL}'")
            raise ValueError("Unmatched '[' in resolution")
        resolutions.append(remainder2[1:res_end].strip())
        remainder2 = remainder2[res_end+1:].strip()
    resolution = 'x'.join(resolutions)
    if 'x' not in resolution:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Resolution '{Fore.BLUE}{resolution}{Style.RESET_ALL}' does not contain 'x'")
        raise ValueError("Resolution format problem")
    elif resolution.count('x') == 1:
        hr, vr = resolution.split('x')
    else:
        hr = vr = 'Unknown'
    if not remainder2.startswith('{'):
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} No source_details braces found in '{Fore.BLUE}{remainder2}{Style.RESET_ALL}'")
        raise ValueError("No source_details braces")
    src_end = remainder2.find('}')
    if src_end == -1:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Unmatched '{{' in source details: '{Fore.BLUE}{remainder2}{Style.RESET_ALL}'")
        raise ValueError("Unmatched '{' in source details")
    source_details = remainder2[1:src_end].strip()
    details = [x.strip() for x in source_details.split(',')]
    Src = details[0] if len(details) >= 1 else ''
    uploader = details[1] if len(details) >= 2 else ''
    return {
        'Category': category,
        'Type': vtype,
        'Style': style,
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

def main():
    raw_csv = 'videos-raw.csv'
    formatted_csv = 'videos-formatted.csv'
    try:
        raw_rows = []
        # CATEGORY
        for cat_entry in os.scandir('.'):
            if not cat_entry.is_dir():
                continue
            category = cat_entry.name
            category_path = cat_entry.path
            if category not in ['Films', 'Series']:
                print(f"{Fore.MAGENTA}DEBUG:{Style.RESET_ALL} Skipping directory '{Fore.BLUE}{category_path}{Style.RESET_ALL}' (not a recognized category).")
                continue

            # TYPE
            for type_entry in os.scandir(category_path):
                if not type_entry.is_dir():
                    continue
                vtype = type_entry.name
                type_path = type_entry.path
                # STYLE
                for style_entry in os.scandir(type_path):
                    if not style_entry.is_dir():
                        continue
                    style = style_entry.name
                    style_path = style_entry.path
                    # SOURCE (no Collection level anymore)
                    for src_entry in os.scandir(style_path):
                        if not src_entry.is_dir():
                            continue
                        source = src_entry.name
                        source_path = src_entry.path
                        # MOVIEFOLDER
                        moviefolders = [
                            mf_entry.name for mf_entry in os.scandir(source_path)
                            if mf_entry.is_dir()
                        ]
                        if not moviefolders:
                            print(f"{Fore.YELLOW}WARNING:{Style.RESET_ALL} Source '{Fore.BLUE}{source_path}{Style.RESET_ALL}' has no movie folders.")
                        for moviefolder in moviefolders:
                            rel_path = os.path.join(category, vtype, style, source, moviefolder)
                            raw_rows.append({'FullPath': rel_path})

        with open(raw_csv, 'w', newline='', encoding='utf-8') as rawfile:
            writer = csv.DictWriter(rawfile, fieldnames=['FullPath'])
            writer.writeheader()
            writer.writerows(raw_rows)

        formatted_rows = []
        with open(raw_csv, newline='', encoding='utf-8') as rawfile:
            reader = csv.DictReader(rawfile)
            for row in reader:
                full_path = row['FullPath']
                try:
                    parsed = split_video(full_path)
                    formatted_rows.append(parsed)
                except ValueError as e:
                    print(f"{Fore.MAGENTA}DEBUG:{Style.RESET_ALL} Skipping directory '{Fore.BLUE}{full_path}{Style.RESET_ALL}' - Reason: {Fore.YELLOW}{str(e)}{Style.RESET_ALL}")
                    continue

        fieldnames = [
            'Category', 'Type', 'Style',
            'Source', 'Title', 'Year', 'MProv', 'MID', 'Edition',
            'Languages', 'Resolution', 'HR', 'VR', 'Src', 'Uploader'
        ]

        with open(formatted_csv, 'w', newline='', encoding='utf-8') as outfile:
            writer = csv.writer(outfile, quoting=csv.QUOTE_MINIMAL)
            writer.writerow(fieldnames)
            for row in formatted_rows:
                output_row = [row.get(field, '') for field in fieldnames]
                writer.writerow(output_row)

        print(f"{Fore.GREEN}SUCCESS:{Style.RESET_ALL} {Fore.BLUE}'{raw_csv}'{Style.RESET_ALL} and {Fore.BLUE}'{formatted_csv}'{Style.RESET_ALL} created")
    except Exception as e:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} {Fore.YELLOW}{str(e)}{Style.RESET_ALL}")
        sys.exit(1)

if __name__ == "__main__":
    main()