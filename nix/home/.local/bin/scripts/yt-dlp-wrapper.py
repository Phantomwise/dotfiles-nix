#!/usr/bin/env python3

import subprocess
import sys

# AI Disclaimer: This script was generated with the assistance of an AI language model.

# Always use this output template
OUTPUT_TEMPLATE = "%(title)s [%(extractor)s, %(uploader_id,channel_id,uploader,channel)s] [%(id)s] [%(format_id)s].%(ext)s"

def contains_user_output_option(args):
    """
    Return True if args contains any form of -o / --output:
      - -o VALUE
      - -oVALUE
      - --output VALUE
      - --output=VALUE
    """
    i = 0
    while i < len(args):
        a = args[i]
        if a == "-o" or a == "--output":
            return True
        if a.startswith("--output="):
            return True
        if a.startswith("-o") and a != "-o":
            # short form with attached value like -oVALUE
            return True
        i += 1
    return False

def strip_user_output_options(args):
    """
    Remove user-supplied -o / --output options (and their values) from args.

    Handles forms:
      - -o VALUE
      - -oVALUE
      - --output VALUE
      - --output=VALUE
    Returns a new list without those options.
    """
    out = []
    i = 0
    while i < len(args):
        a = args[i]
        if a == "-o" or a == "--output":
            # skip this token and the next token (the value) if present
            i += 2
            continue
        if a.startswith("--output="):
            # skip this token
            i += 1
            continue
        if a.startswith("-o") and a != "-o":
            # short form with attached value like -oVALUE -> skip
            i += 1
            continue
        # otherwise keep it
        out.append(a)
        i += 1
    return out

def main():
    # Forward all command-line tokens the user provided (we'll filter -o/--output)
    forwarded = sys.argv[1:]

    # Warn if the user included -o/--output (any form); we will still use the wrapper OUTPUT_TEMPLATE.
    if contains_user_output_option(forwarded):
        print("Warning: user-supplied -o/--output detected — wrapper's output template will be used instead", file=sys.stderr)

    # Remove any user-supplied -o/--output options to avoid conflicts
    forwarded = strip_user_output_options(forwarded)

    # Always prompt for the URL (per your workflow).
    url = input("Enter the video URL: ").strip()

    # Build the yt-dlp command: program name, wrapper's -o template, forwarded args, then the URL.
    cmd = ["yt-dlp", "-o", OUTPUT_TEMPLATE]
    if forwarded:
        cmd.extend(forwarded)
    cmd.append(url)

    # Uncomment the next line to print the assembled command for debugging:
    # print("Running:", " ".join(cmd))

    try:
        subprocess.run(cmd)
    except KeyboardInterrupt:
        # Clean, short message when the user hits Ctrl+C instead of a full Python traceback.
        print("\nInterrupted by user")

if __name__ == "__main__":
    main()