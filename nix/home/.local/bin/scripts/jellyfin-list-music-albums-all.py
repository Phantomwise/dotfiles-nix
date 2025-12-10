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
#
#   Album folder name format (all fields required; some bracketed fields may be empty):
#       title (original_year) (nb medium) (tracks) [issue_year] [label] [catalog] [barcode]
#   Example:
#       My Album Title (1975) (2 CD) (18) [1999] [SomeLabel] [CAT-001] [1234567890123]

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


def split_album(album, album_path=None):
    """
    Splits album folder name into:
    - album title
    - original_year (third-to-last parenthetical)
    - disc count and medium (second-to-last parenthetical)
    - tracks (last parenthetical) -> integer
    - issue_year (first bracketed)
    - label, catalog, barcode (next brackets)

    Raises ValueError if expected parenthetical or bracket is missing or malformed.

    album_path: optional full path (not used for the concise error messages).
    """
    # Always use the concise folder name for in-function error messages
    display = album

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

    # Expect three parentheticals: original_year, disc info, tracks
    if len(parens) < 3:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Not enough parentheticals in album '{Fore.CYAN}{display}{Style.RESET_ALL}'; expected (original_year) (nb medium) (tracks).")
        raise ValueError(f"Not enough parentheticals in '{album}'")

    original_year = parens[-3]
    disc_info = parens[-2]
    tracks_str = parens[-1]

    parts = disc_info.split(' ')
    if len(parts) != 2:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Disc info malformed in album '{Fore.YELLOW}{display}{Style.RESET_ALL}': '{Fore.BLUE}{disc_info}{Style.RESET_ALL}'")
        raise ValueError(f"Disc info malformed in '{album}'")
    disc_count, medium = parts

    if tracks_str == '':
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Tracks parenthetical is empty in album '{Fore.YELLOW}{display}{Style.RESET_ALL}'")
        raise ValueError(f"Tracks missing in '{album}'")
    try:
        tracks = int(tracks_str)
    except ValueError:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Tracks must be an integer in album '{Fore.YELLOW}{display}{Style.RESET_ALL}': '{Fore.BLUE}{tracks_str}{Style.RESET_ALL}'")
        raise ValueError(f"Tracks not integer in '{album}'")

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
                print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Unmatched '[' in album '{Fore.YELLOW}{display}{Style.RESET_ALL}'")
                raise ValueError(f"Unmatched '[' in '{album}'")
            brackets.append(remainder[idx + 1:close_idx].strip())
            idx = close_idx + 1
        else:
            idx += 1

    if len(brackets) < 4:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Album '{Fore.YELLOW}{display}{Style.RESET_ALL}' must have 4 bracketed values: [issue_year] [label] [catalog] [barcode]")
        raise ValueError(f"Not enough bracketed values in '{album}'")

    issue_year, label, catalog, barcode = brackets[:4]

    return album_title, original_year, disc_count, medium, tracks, issue_year, label, catalog, barcode


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

                # Detect whether there's an artist level (artist folders containing albums).
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

                # Special-case: Soundtrack types are album-level (no artist layer),
                # even if the album folders contain per-disc subfolders.
                if tname.lower() == 'soundtrack':
                    has_artist_level = False

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
                            print(f"{Fore.YELLOW}WARNING:{Style.RESET_ALL} Artist '{Fore.CYAN}{artist_path}{Style.RESET_ALL}' has no album folders.")
                        for album in album_dirs:
                            raw_rows.append({
                                'Artist': artist,
                                'Album': album,
                                'Source': source,
                                'Type': tname
                            })
                else:
                    # No artist layer: treat entries under Type as albums.
                    for album_entry in type_children:
                        if should_skip(album_entry.name):
                            continue
                        album = album_entry.name
                        raw_rows.append({
                            'Artist': '',
                            'Album': album,
                            'Source': source,
                            'Type': tname
                        })

        raw_csv = 'music-albums-raw.csv'
        formatted_csv = 'music-albums-formatted.csv'
        with open(raw_csv, 'w', newline='', encoding='utf-8') as rawfile:
            fieldnames = ['Artist', 'Album', 'Source', 'Type']
            writer = csv.DictWriter(rawfile, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerows(raw_rows)

        formatted_rows = []
        with open(raw_csv, newline='', encoding='utf-8') as rawfile:
            reader = csv.DictReader(rawfile)
            for row in reader:
                album = row['Album']
                # Construct full path from current working directory for clearer debug output.
                parts = ['.', 'Music', 'Audio', 'Collection', row.get('Source', ''), row.get('Type', '')]
                artist_field = row.get('Artist', '')
                if artist_field:
                    parts.append(artist_field)
                parts.append(album)
                album_path = os.path.join(*parts)
                try:
                    (album_title, original_year, disc_count, medium, tracks,
                     issue_year, label, catalog, barcode) = split_album(album, album_path=album_path)
                    formatted_rows.append({
                        'Source': row.get('Source', ''),
                        'Type': row.get('Type', ''),
                        'Artist': row.get('Artist', ''),
                        'Album': album_title,
                        'OYear': original_year,
                        'Nb': disc_count,
                        'Tracks': tracks,
                        'Medium': medium,
                        'IYear': issue_year,
                        'Label': label,
                        'Catalog': catalog,
                        'Barcode': "#"+barcode
                    })
                except ValueError as e:
                    # Print the concise skip reason, then print the full path on a separate DEBUG line for readability.
                    print(f"{Fore.MAGENTA}DEBUG:{Style.RESET_ALL} Skipping album '{Fore.CYAN}{album}{Style.RESET_ALL}' - Reason: {Fore.YELLOW}{str(e)}{Style.RESET_ALL}")
                    print(f"{Fore.MAGENTA}DEBUG:{Style.RESET_ALL} Full path: '{Fore.BLUE}{album_path}{Style.RESET_ALL}'")
                    continue

        fieldnames = ['Source', 'Type', 'Artist', 'Album', 'OYear', 'Nb', 'Tracks', 'Medium', 'IYear', 'Label', 'Catalog', 'Barcode']
        text_fields = {'Artist', 'Album', 'Barcode', 'Source', 'Type', 'Label'}

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