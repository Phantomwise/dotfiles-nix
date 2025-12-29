#!/usr/bin/env bash

# Enable nullglob to handle no matches gracefully
shopt -s nullglob

# Check if at least two arguments are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <track_spec> <language> [language-ietf]"
    echo "Example: $0 a0 eng eng"
    exit 1
fi

STREAM=$1
LANGUAGE=$2
LANGUAGE_IETF=$3

# Parse the stream spec: e.g., a0 -> a:0 (0-based indexing, explicit type required)
TYPE=${STREAM:0:1}
INDEX=${STREAM:1}

case $TYPE in
    a) STREAM_SPEC="a:$INDEX" ;;
    v) STREAM_SPEC="v:$INDEX" ;;
    s) STREAM_SPEC="s:$INDEX" ;;
    *) echo "Invalid track spec: $STREAM. Must start with a, v, or s."; exit 1 ;;
esac

for f in *; do
    if [ -f "$f" ]; then
        echo "Processing $f"
        # Backup the file
        mv "$f" "${f}.bak"
        # Build the ffmpeg command
        ARGS=(-i "${f}.bak" -map 0 -c copy -metadata:s:$STREAM_SPEC language=$LANGUAGE)
        if [ -n "$LANGUAGE_IETF" ]; then
            ARGS+=(-metadata:s:$STREAM_SPEC language-ietf=$LANGUAGE_IETF)
        fi
        ARGS+=(-y "$f")
        ffmpeg "${ARGS[@]}"
        # Remove backup if successful
        if [ $? -eq 0 ]; then
            rm "${f}.bak"
        else
            echo "Error processing $f, backup kept as ${f}.bak"
        fi
    fi
done
