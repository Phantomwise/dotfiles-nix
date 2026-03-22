#!/usr/bin/env bash

# Enable nullglob to handle no matches gracefully and nocaseglob for case-insensitive extensions
shopt -s nullglob nocaseglob

# Require ffmpeg
command -v ffmpeg >/dev/null 2>&1 || { echo "ffmpeg is required but not found in PATH"; exit 1; }
command -v ffprobe >/dev/null 2>&1 || { echo "ffprobe is required but not found in PATH"; exit 1; }

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

# Whitelist of common video/container extensions (lowercase; nocaseglob makes matching case-insensitive)
EXTENSIONS=(3gp avi flv m2ts m4v mk3d mkv mov mp4 mpg mpeg ogv ts webm wmv)

processed=0

for ext in "${EXTENSIONS[@]}"; do
    for f in *."$ext"; do
        # nullglob + nocaseglob means this loop skips if there are no matches
        if [ -f "$f" ]; then
            processed=$((processed + 1))
            echo "Processing $f"
            # Backup the file
            mv "$f" "${f}.bak"
            # Build the ffmpeg command
            ARGS=(-i "${f}.bak" -map 0 -c copy -metadata:s:$STREAM_SPEC language=$LANGUAGE)
            if [ -n "$LANGUAGE_IETF" ]; then
                ARGS+=(-metadata:s:$STREAM_SPEC language-ietf=$LANGUAGE_IETF)
            fi
            ARGS+=(-y "$f")
            if ffmpeg "${ARGS[@]}"; then
                rm "${f}.bak"
            else
                echo "Error processing $f, backup kept as ${f}.bak"
            fi
        fi
    done
done

if [ "$processed" -eq 0 ]; then
    echo "No media files found with extensions: ${EXTENSIONS[*]}"
fi