#!/usr/bin/env bash

# Enable nullglob to handle no matches gracefully
shopt -s nullglob

# Check if at least two arguments are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <track_spec> <language> [language-ietf]"
    echo "Example: $0 a1 eng eng"
    exit 1
fi

STREAM=$1
LANGUAGE=$2
LANGUAGE_IETF=$3

for f in *.mkv *.webm *.mka *.mks *.mk3d; do
    if [ -f "$f" ]; then
        echo "Processing $f"
        # Build the command arguments
        ARGS=("$f" --edit track:$STREAM --set language=$LANGUAGE)
        if [ -n "$LANGUAGE_IETF" ]; then
            ARGS+=(--set language-ietf=$LANGUAGE_IETF)
        fi
        mkvpropedit "${ARGS[@]}"
    fi
done