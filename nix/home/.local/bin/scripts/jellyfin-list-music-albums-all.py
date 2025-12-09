#!/usr/bin/env python3

import os
import csv
import sys
import atexit
from datetime import datetime, timezone
from colorama import Fore, Style, init

init(autoreset=True)

# AI Disclaimer: This script was generated with the assistance of an AI language model.
#
# Description:
#   Walks a music collection rooted at the current directory and expects:
#       Music/Audio/Collection/<Source>/<Type>/Artist/Album
#   If <Type> = Soundtrack, expects:
#       Music/Audio/Collection/<Source>/Soundtrack/Album
#   Supports the case where <Type> directly contains Album folders (e.g. Soundtrack).
#   Writes music-albums-raw.csv and music-albums-formatted.csv.
#   Captures stdout and stderr and writes them to music-albums.log (overwritten each run)
#   while still printing to the console.

LOG_FILE = 'music-albums.log'


class StreamTee:
    """Tee-like stream: write to original stream and to a log file."""
    def __init__(self, orig_stream, log_file):
        self.orig = orig_stream
        self.logf = log_file

    def write(self, text):
        # Write to original (console)
        try:
            self.orig.write(text)
        except Exception:
            pass
        # Write to log file (no-op if closed)
        try:
            self.logf.write(text)
        except Exception:
            pass

    def flush(self):
        try:
            self.orig.flush()
        except Exception:
            pass
        try:
            self.logf.flush()
        except Exception:
            pass

    @property
    def encoding(self):
        return getattr(self.orig, "encoding", "utf-8")


def setup_stdout_stderr_capture(path=LOG_FILE):
    """Replace sys.stdout and sys.stderr with tee wrappers that also write to log file.

    The log file is opened with mode 'w' so it is overwritten each run.
    """
    # Open log file in write mode to overwrite previous runs
    logf = open(path, "w", encoding="utf-8")
    # Write a run header with timezone-aware timestamp
    header = f"--- Run at {datetime.now(timezone.utc).isoformat()} ---\n"
    logf.write(header)
    logf.flush()

    # Notify user that the log file was created
    print(f"{Fore.GREEN}SUCCESS:{Style.RESET_ALL} Created '{Fore.CYAN}{path}{Style.RESET_ALL}'")

    orig_stdout = sys.stdout
    orig_stderr = sys.stderr

    sys.stdout = StreamTee(orig_stdout, logf)
    sys.stderr = StreamTee(orig_stderr, logf)

    # Ensure the log file is closed and streams restored on exit
    def restore():
        try:
            # flush wrappers first
            try:
                sys.stdout.flush()
                sys.stderr.flush()
            except Exception:
                pass
            # restore originals
            try:
                sys.stdout = orig_stdout
                sys.stderr = orig_stderr
            except Exception:
                pass
            # write footer and close logfile
            try:
                logf.write(f"\n--- End run at {datetime.now(timezone.utc).isoformat()} ---\n")
                logf.flush()
                logf.close()
            except Exception:
                pass
        except Exception:
            pass

    # Use atexit to restore on normal exit
    atexit.register(restore)


def should_skip(name):
    """Return True for directories that should be ignored (start with '_')."""
    return name.startswith('_')


def split_album(album):
    """
    Splits album folder name into:
    - album title
    - original_year (second-to-last parenthetical)
    - disc count and medium (last parenthetical)
    - issue_year (first bracketed)
    - label, catalog, barcode (next brackets)

    Raises ValueError if expected parenthetical or bracket is missing or malformed.
    """
    parens = []
    start = len(album)
    while True:
        close_idx = album.rfind(')', 0, start)
        if close_idx == -1:
            break
        open_idx = album.rfind('(', 0, close_idx)
        if open_idx == -1:
            break
        parens.insert(0, album[open_idx + 1:close_idx].strip())
        start = open_idx

    if len(parens) < 2:
        print(f"{Fore.RED}Error:{Style.RESET_ALL} No parentheticals found in album '{Fore.YELLOW}{album}{Style.RESET_ALL}'; disc info and year are required.")
        raise ValueError(f"No parentheticals in '{album}'")

    original_year = parens[-2]
    disc_info = parens[-1]

    parts = disc_info.split(' ')
    if len(parts) != 2:
        print(f"{Fore.RED}Error:{Style.RESET_ALL} Disc info malformed in album '{Fore.YELLOW}{album}{Style.RESET_ALL}': '{Fore.CYAN}{disc_info}{Style.RESET_ALL}'")
        raise ValueError(f"Disc info malformed in '{album}'")
    disc_count, medium = parts

    title_end = album.rfind(f'({original_year})')
    album_title = album[:title_end].strip() if title_end != -1 else album

    brackets = []
    last_paren = album.rfind(')')
    remainder = album[last_paren + 1:] if last_paren != -1 else ''
    idx = 0
    while idx < len(remainder):
        if remainder[idx] == '[':
            close_idx = remainder.find(']', idx)
            if close_idx == -1:
                print(f"{Fore.RED}Error:{Style.RESET_ALL} Unmatched '[' in album '{Fore.YELLOW}{album}{Style.RESET_ALL}'")
                raise ValueError(f"Unmatched '[' in '{album}'")
            brackets.append(remainder[idx + 1:close_idx].strip())
            idx = close_idx + 1
        else:
            idx += 1

    if len(brackets) < 4:
        print(f"{Fore.RED}Error:{Style.RESET_ALL} Album '{Fore.YELLOW}{album}{Style.RESET_ALL}' must have 4 bracketed values: [issue_year] [label] [catalog] [barcode]")
        raise ValueError(f"Not enough bracketed values in '{album}'")

    issue_year, label, catalog, barcode = brackets[:4]

    return album_title, original_year, disc_count, medium, issue_year, label, catalog, barcode


def main():
    try:
        music_root = os.path.join('.', 'Music')
        if not os.path.isdir(music_root):
            print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Could not find 'Music' directory in the current path: {os.getcwd()}")
            sys.exit(1)

        audio_path = os.path.join(music_root, 'Audio')
        if not os.path.isdir(audio_path):
            print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Could not find 'Audio' under 'Music' (expected Music/Audio/...)")
            sys.exit(1)

        collection_root = os.path.join(audio_path, 'Collection')
        if not os.path.isdir(collection_root):
            print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Could not find 'Collection' under 'Music/Audio' (expected Music/Audio/Collection/...)")
            sys.exit(1)

        raw_rows = []
        for coll_entry in os.scandir(collection_root):
            if not coll_entry.is_dir():
                continue
            if should_skip(coll_entry.name):
                continue
            source_path = coll_entry.path
            source = coll_entry.name
            for type_entry in os.scandir(source_path):
                if not type_entry.is_dir():
                    continue
                if should_skip(type_entry.name):
                    continue
                tpath = type_entry.path
                tname = type_entry.name

                type_children = [entry for entry in os.scandir(tpath) if entry.is_dir() and not should_skip(entry.name)]
                if not type_children:
                    print(f"{Fore.YELLOW}WARNING:{Style.RESET_ALL} Type '{Fore.BLUE}{tpath}{Style.RESET_ALL}' has no artist or album folders.")
                    continue

                has_artist_level = False
                for child in type_children:
                    try:
                        for grandchild in os.scandir(child.path):
                            if grandchild.is_dir() and not should_skip(grandchild.name):
                                has_artist_level = True
                                break
                        if has_artist_level:
                            break
                    except PermissionError:
                        continue

                if has_artist_level:
                    for artist_entry in type_children:
                        if not artist_entry.is_dir():
                            continue
                        if should_skip(artist_entry.name):
                            continue
                        artist = artist_entry.name
                        artist_path = artist_entry.path
                        album_dirs = [a.name for a in os.scandir(artist_path) if a.is_dir() and not should_skip(a.name)]
                        if not album_dirs:
                            print(f"{Fore.YELLOW}WARNING:{Style.RESET_ALL} Artist '{Fore.BLUE}{artist_path}{Style.RESET_ALL}' has no album folders.")
                        for album in album_dirs:
                            raw_rows.append({
                                'Artist': artist,
                                'Album': album,
                                'Source': source,
                                'Type': tname,
                                'Collection': coll_entry.name
                            })
                else:
                    for album_entry in type_children:
                        if should_skip(album_entry.name):
                            continue
                        album = album_entry.name
                        raw_rows.append({
                            'Artist': 'None',
                            'Album': album,
                            'Source': source,
                            'Type': tname,
                            'Collection': coll_entry.name
                        })

        raw_csv = 'music-albums-raw.csv'
        formatted_csv = 'music-albums-formatted.csv'
        with open(raw_csv, 'w', newline='', encoding='utf-8') as rawfile:
            fieldnames = ['Artist', 'Album', 'Source', 'Type', 'Collection']
            writer = csv.DictWriter(rawfile, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(raw_rows)

        formatted_rows = []
        with open(raw_csv, newline='', encoding='utf-8') as rawfile:
            reader = csv.DictReader(rawfile)
            for row in reader:
                album = row['Album']
                try:
                    (album_title, original_year, disc_count, medium,
                     issue_year, label, catalog, barcode) = split_album(album)
                    formatted_rows.append({
                        'Source': row.get('Source', ''),
                        'Type': row.get('Type', ''),
                        'Artist': row.get('Artist', ''),
                        'Album': album_title,
                        'OYear': original_year,
                        'Nb': disc_count,
                        'Medium': medium,
                        'IYear': issue_year,
                        'Label': label,
                        'Catalog': catalog,
                        'Barcode': "#"+barcode,
                        'Collection': row.get('Collection', '')
                    })
                except ValueError as e:
                    print(f"{Fore.MAGENTA}DEBUG:{Style.RESET_ALL} Skipping album '{Fore.BLUE}{album}{Style.RESET_ALL}' - Reason: {Fore.YELLOW}{str(e)}{Style.RESET_ALL}")
                    continue

        fieldnames = ['Source', 'Type', 'Artist', 'Album', 'OYear', 'Nb', 'Medium', 'IYear', 'Label', 'Catalog', 'Barcode', 'Collection']
        text_fields = {'Artist', 'Album', 'Barcode', 'Source', 'Type', 'Collection', 'Label'}

        with open(formatted_csv, 'w', newline='', encoding='utf-8') as outfile:
            writer = csv.writer(outfile, quoting=csv.QUOTE_MINIMAL)
            writer.writerow(fieldnames)
            for row in formatted_rows:
                output_row = []
                for field in fieldnames:
                    value = row.get(field, '')
                    if field in text_fields:
                        value = str(value).replace('"', '""')
                        value = f'"{value}"'
                    output_row.append(value)
                outfile.write(','.join(str(v) for v in output_row) + '\n')

        print(f"{Fore.GREEN}SUCCESS:{Style.RESET_ALL} Created '{Fore.CYAN}{raw_csv}{Style.RESET_ALL}' and '{Fore.CYAN}{formatted_csv}{Style.RESET_ALL}'")
    except Exception as e:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} {Fore.YELLOW}{str(e)}{Style.RESET_ALL}")
        sys.exit(1)


if __name__ == "__main__":
    # Start capturing stdout/stderr to music-albums.log while still printing to console
    setup_stdout_stderr_capture(LOG_FILE)
    main()