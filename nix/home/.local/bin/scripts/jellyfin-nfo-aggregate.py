#!/usr/bin/env python3

import os
import sys
import atexit
import linecache
import re
import xml.etree.ElementTree as ET
from datetime import datetime, timezone
from colorama import Fore, Style, init

init(autoreset=True)

# AI Disclaimer: This script was generated with the assistance of an AI language model.

# Description:
#   Traverses video folders (movies/series) in the nested directory structure:
#   <Category>/<Type>/<Style>/<Source>/<Movie Folder>
#   For each folder, reads movie.nfo (for Films*) or tvshow.nfo (for Series),
#   extracts all <tag> elements, aggregates them (removing duplicates, sorting alphabetically),
#   and outputs an aggregate.nfo file in the current directory.
#   Category can be 'Films', 'Series', or 'Films-Short'.
#
# Changes in this version:
# - Reuses traversal logic from the original script.
# - Parses NFO files for tags instead of parsing folder names.
# - Aggregates all unique tags into a single XML file.

LOG_FILE = 'jellyfin-nfo-tag-aggregate.log'

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


def extract_tags_from_nfo(nfo_path):
    """Extract all <tag> elements from an NFO file."""
    try:
        tree = ET.parse(nfo_path)
        root = tree.getroot()
        tags = [tag.text for tag in root.findall('tag') if tag.text]
        return tags
    except ET.ParseError as e:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} Failed to parse '{Fore.CYAN}{nfo_path}{Style.RESET_ALL}': {Fore.YELLOW}{str(e)}{Style.RESET_ALL}")
        # Try to extract line number from the error message since e.lineno may be None
        match = re.search(r'line (\d+)', str(e))
        if match:
            lineno = int(match.group(1))
            bad_line = linecache.getline(nfo_path, lineno).strip()
            if bad_line:
                print(f"{Fore.MAGENTA}Content of line {lineno}:{Style.RESET_ALL} {bad_line}")
            else:
                print(f"{Fore.MAGENTA}Could not retrieve content of line {lineno}.{Style.RESET_ALL}")
        return []
    except FileNotFoundError:
        print(f"{Fore.YELLOW}WARNING:{Style.RESET_ALL} NFO file not found: '{Fore.CYAN}{nfo_path}{Style.RESET_ALL}'")
        return []


def main():
    aggregate_nfo = 'jellyfin-nfo-tag-aggregate.nfo'
    all_tags = set()
    try:
        # Only check the known top-level category directories to avoid scanning all entries
        for category in ['Films', 'Series', 'Films-Short']:
            category_path = os.path.join('.', category)
            if not os.path.isdir(category_path):
                print(f"{Fore.MAGENTA}DEBUG:{Style.RESET_ALL} Category '{Fore.CYAN}{category_path}{Style.RESET_ALL}' not found; skipping.")
                continue

            nfo_filename = 'movie.nfo' if category.startswith('Films') else 'tvshow.nfo'

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
                            folder_path = os.path.join(source_path, moviefolder)
                            nfo_path = os.path.join(folder_path, nfo_filename)
                            tags = extract_tags_from_nfo(nfo_path)
                            all_tags.update(tags)

        # Sort tags alphabetically
        sorted_tags = sorted(all_tags)

        # Write aggregate NFO
        with open(aggregate_nfo, 'w', encoding='utf-8') as outfile:
            outfile.write('<?xml version="1.0" encoding="utf-8" standalone="yes"?>\n')
            outfile.write('<movie>\n')
            for tag_text in sorted_tags:
                outfile.write(f'  <tag>{tag_text}</tag>\n')
            outfile.write('</movie>\n')

        print(f"{Fore.GREEN}SUCCESS:{Style.RESET_ALL} {Fore.CYAN}'{aggregate_nfo}'{Style.RESET_ALL} created with {len(sorted_tags)} unique tags")
    except Exception as e:
        print(f"{Fore.RED}ERROR:{Style.RESET_ALL} {Fore.YELLOW}{str(e)}{Style.RESET_ALL}")
        sys.exit(1)


if __name__ == "__main__":
    # Start capturing stdout_stderr_capture(LOG_FILE)
    main()