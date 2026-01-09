#!/usr/bin/env python3

import os
import csv
import sys
import atexit
from datetime import datetime, timezone
from colorama import Fore, Style, init

init(autoreset=True)

# AI Disclaimer: This script was generated with the assistance of an AI language model.

# Description:
#   Lists video files (movies/series) in a nested directory structure:
#   <Category>/<Type>/<Style>/<Source>/<Movie Folder>
#   Outputs CSV file with Category, Type, Style, Source, and other info.
#   Category can be only 'Films' or 'Series'.
#   Previously there was a 'Collection' layer; this script has been updated to remove it.
#
# Changes in this version:
# - Accept new filename format:
#     Title (Year) [dbid] - Edition [lang] [resolution] {source}
#   where:
#     - the bracketed metadata formerly called "metadata" is now treated as dbid
#       and split into DB provider and DB id on the first '-'
#     - languages are in brackets [lang] (not parentheses)
#     - resolution is a bracket containing dimensions (e.g. 1920x1080). ptag (e.g. 1080p)
#       is intentionally not used; dimensions are the source of truth.
# - Edition is optional and is treated as plain text (like title), not bracketed.
# - Uploader in the {source, uploader} braces is optional.

LOG_FILE = 'videos.log'

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
    The function writes a success line to the original stdout before replacing
    the streams, so the user always sees the "Created '<logfile>'" message.
    """
    # Capture originals first so we can write to them before replacing
    orig_stdout = sys.stdout
    orig_stderr = sys.stderr

    # Open log file in write mode to overwrite previous runs
    logf = open(path, "w", encoding="utf-8")
    # Write a run header with timezone-aware timestamp
    header = f"--- Run at {datetime.now(timezone.utc).isoformat()} ---\n"
    logf.write(header)
    logf.flush()

    # Notify user that the log file was created (write to original stdout)
    try:
        orig_stdout.write(f"{Fore.GREEN}SUCCESS:{Style.RESET_ALL} Created '{Fore.CYAN}{path}{Style.RESET_ALL}'\n")
        orig_stdout.flush()
    except Exception:
        # Fallback to print if write fails for some reason
        try:
            print(f"{Fore.GREEN}SUCCESS:{Style.RESET_ALL} Created '{Fore.CYAN}{path}{Style.RESET_ALL}'")
        except Exception:
            pass

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
      - DBProv (database/provider)
      - DBID (database id)
      - Edition (may be empty)
      - Languages
      - Resolution
      - HR (Horizontal Resolution)
      - VR (Vertical Resolution)
      - Src
      - Uploader

    Expected new folder format:
      Title (Year) [dbprov-db id] - Edition [lang] [1920x1080] {Source, Uploader}

    Notes:
    - Edition is optional (may be empty string)
    - Languages are bracketed: [eng,jpn]
    - Resolution must be bracketed and contain dimensions (e.g. 1920x1080)
    - Uploader in braces is optional
    """
    parts = path.split(os.path.sep)
    if len(parts) < 5:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Path '{Fore.BLUE}{path}{Style.RESET_ALL}' does not have enough levels (need at least 5)")
        raise ValueError("Not enough levels")
    category, vtype, style, source, remainder = parts[:5]
    year_start = remainder.find('(')
    year_end = remainder.find(')')
    if year_start == -1 or year_end == -1 or year_end < year_start:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} No year parenthetical in '{Fore.CYAN}{remainder}{Style.RESET_ALL}'")
        raise ValueError("No year parenthetical")
    title = remainder[:year_start].strip()
    year = remainder[year_start+1:year_end].strip()
    remainder2 = remainder[year_end+1:].strip()
    if not remainder2.startswith('['):
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} No dbid bracket in '{Fore.CYAN}{remainder2}{Style.RESET_ALL}'")
        raise ValueError("No dbid bracket")
    meta_end = remainder2.find(']')
    if meta_end == -1:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Unmatched '[' in dbid: '{Fore.CYAN}{remainder2}{Style.RESET_ALL}'")
        raise ValueError("Unmatched '[' in dbid")
    dbid = remainder2[1:meta_end].strip()
    remainder2 = remainder2[meta_end+1:].strip()
    # split dbid into provider and id on first '-'
    if '-' not in dbid:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} DBID malformed (expected 'provider-id'): '{Fore.MAGENTA}{dbid}{Style.RESET_ALL}'")
        raise ValueError("DBID malformed")
    db_provider, db_id = dbid.split('-', 1)

    # After dbid we expect a '-' separator before edition / release metadata
    if not remainder2.startswith('-'):
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Expected '-' separator for edition in '{Fore.CYAN}{remainder2}{Style.RESET_ALL}'")
        raise ValueError("Expected '-' for edition")
    remainder2 = remainder2[1:].strip()

    # Edition is optional. If the next char is '[' then there's no edition text.
    edition_details = ''
    if not remainder2.startswith('['):
        br_idx = remainder2.find('[')
        if br_idx == -1:
            print(f"{Fore.RED}ERROR:{Style.RESET_ALL} No opening '[' for languages after edition in '{Fore.CYAN}{remainder2}{Style.RESET_ALL}'")
            raise ValueError("No languages bracket after edition")
        edition_details = remainder2[:br_idx].strip()
        remainder2 = remainder2[br_idx:].strip()

    # Now we expect languages in brackets [lang]
    if not remainder2.startswith('['):
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} No languages bracket found in '{Fore.CYAN}{remainder2}{Style.RESET_ALL}'")
        raise ValueError("No languages bracket")
    lang_end = remainder2.find(']')
    if lang_end == -1:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Unmatched '[' in languages: '{Fore.CYAN}{remainder2}{Style.RESET_ALL}'")
        raise ValueError("Unmatched '[' in languages")
    languages = remainder2[1:lang_end].strip()
    remainder2 = remainder2[lang_end+1:].strip()

    # Next we expect a resolution bracket with dimensions (e.g. [1920x1080])
    if not remainder2.startswith('['):
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} No resolution bracket found after languages in '{Fore.CYAN}{remainder2}{Style.RESET_ALL}'")
        raise ValueError("No resolution bracket")
    res_end = remainder2.find(']')
    if res_end == -1:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Unmatched '[' in resolution: '{Fore.CYAN}{remainder2}{Style.RESET_ALL}'")
        raise ValueError("Unmatched '[' in resolution")
    resolution = remainder2[1:res_end].strip()
    remainder2 = remainder2[res_end+1:].strip()

    # resolution must be dimensions containing 'x' (horizontal x vertical)
    if 'x' not in resolution:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Resolution '{Fore.CYAN}{resolution}{Style.RESET_ALL}' must contain 'x' (e.g. 1920x1080)")
        raise ValueError("Resolution format problem")
    # If resolution contains exactly one 'x' parse HR and VR, otherwise mark unknown
    if resolution.count('x') == 1:
        hr, vr = resolution.split('x')
        hr = hr.strip()
        vr = vr.strip()
    else:
        hr = vr = 'Unknown'

    # Finally, source details must be in braces {Source, Uploader}
    if not remainder2.startswith('{'):
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} No source_details braces found in '{Fore.CYAN}{remainder2}{Style.RESET_ALL}'")
        raise ValueError("No source_details braces")
    src_end = remainder2.find('}')
    if src_end == -1:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Unmatched '{{' in source details: '{Fore.CYAN}{remainder2}{Style.RESET_ALL}'")
        raise ValueError("Unmatched '{' in source details")
    source_details = remainder2[1:src_end].strip()
    details = [x.strip() for x in source_details.split(',') if x.strip()]
    Src = details[0] if len(details) >= 1 else ''
    uploader = details[1] if len(details) >= 2 else ''
    return {
        'Category': category,
        'Type': vtype,
        'Style': style,
        'Source': source,
        'Title': title,
        'Year': year,
        'DBProv': db_provider,
        'DBID': db_id,
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
        # Only check the known top-level category directories to avoid scanning all entries
        for category in ['Films', 'Series']:
            category_path = os.path.join('.', category)
            if not os.path.isdir(category_path):
                print(f"{Fore.MAGENTA}DEBUG:{Style.RESET_ALL} Category '{Fore.CYAN}{category_path}{Style.RESET_ALL}' not found; skipping.")
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
                            print(f"{Fore.YELLOW}WARNING:{Style.RESET_ALL} Source '{Fore.CYAN}{source_path}{Style.RESET_ALL}' has no movie folders.")
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
                    print(f"{Fore.MAGENTA}DEBUG:{Style.RESET_ALL} Skipping directory '{Fore.CYAN}{full_path}{Style.RESET_ALL}' - Reason: {Fore.YELLOW}{str(e)}{Style.RESET_ALL}")
                    continue

        fieldnames = [
            'Category', 'Type', 'Style',
            'Source', 'Title', 'Year', 'DBProv', 'DBID', 'Edition',
            'Languages', 'Resolution', 'HR', 'VR', 'Src', 'Uploader'
        ]

        with open(formatted_csv, 'w', newline='', encoding='utf-8') as outfile:
            writer = csv.writer(outfile, quoting=csv.QUOTE_MINIMAL)
            writer.writerow(fieldnames)
            for row in formatted_rows:
                output_row = [row.get(field, '') for field in fieldnames]
                writer.writerow(output_row)

        print(f"{Fore.GREEN}SUCCESS:{Style.RESET_ALL} {Fore.CYAN}'{raw_csv}'{Style.RESET_ALL} and {Fore.CYAN}'{formatted_csv}'{Style.RESET_ALL} created")
    except Exception as e:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} {Fore.YELLOW}{str(e)}{Style.RESET_ALL}")
        sys.exit(1)

if __name__ == "__main__":
    # Start capturing stdout/stderr to videos.log while still printing to console
    setup_stdout_stderr_capture(LOG_FILE)
    main()