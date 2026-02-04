#!/usr/bin/env bash

# Add YouTube metadata to media files (no re-encoding)
# - For .mkv and .webm files, prefer mkvpropedit (in-place).
# - If mkvpropedit cannot write tags in-place, remux using mkvmerge (not ffmpeg).
# - For other container types, fall back to ffmpeg remux (stream-copy).
# Usage: place in $PATH and run from the directory holding files to tag
# Dependencies: yt-dlp, mkvpropedit (mkvtoolnix), mkvmerge (mkvtoolnix), ffmpeg (for non-mkv/webm fallback)
# Optional: jq (recommended)
#
# AI Disclaimer: This script was partially written with the assistance of an AI language model.

set -euo pipefail
shopt -s nullglob

declare -r info="\033[1;33m[INFO]\033[0m"
declare -r succ="\033[1;32m[SUCCESS]\033[0m"
declare -r warn="\033[1;35m[WARN]\033[0m"
declare -r err="\033[1;31m[ERROR]\033[0m"

# yt-dlp arguments (adjust to your environment)
EXTRACTOR_ARGS=( --extractor-args 'youtube:player-client=default,-tv' )
COOKIES_ARGS=( --cookies-from-browser firefox )

_mktmp() { mktemp "${TMPDIR:-/tmp}/ytmeta.XXXXXX"; }

# Escape ']]>' sequences for safe CDATA embedding
_escape_cdata() {
  local s="$1"
  printf '%s' "${s//]]>/]]]]><![CDATA[>}"
}

# Fetch metadata JSON once and extract fields; sets globals:
# _meta_title, _meta_artist, _meta_description, _meta_date
fetch_metadata() {
  local youtube_id="$1"
  local json
  json=$(yt-dlp "${EXTRACTOR_ARGS[@]}" "${COOKIES_ARGS[@]}" -j "https://www.youtube.com/watch?v=$youtube_id" 2>/dev/null || true)

  _meta_title=""
  _meta_artist=""
  _meta_description=""
  _meta_date=""

  if [[ -n "$json" ]]; then
    if command -v jq >/dev/null 2>&1; then
      _meta_title=$(printf '%s' "$json" | jq -r '.title // ""')
      _meta_artist=$(printf '%s' "$json" | jq -r '.uploader_id // .channel_id // .uploader // .channel // ""')
      _meta_description=$(printf '%s' "$json" | jq -r '.description // ""')
      local date_raw
      date_raw=$(printf '%s' "$json" | jq -r '.upload_date // .release_date // ""')
    else
      # python fallback
      _meta_title=$(printf '%s' "$json" | python3 -c 'import sys,json; j=json.load(sys.stdin); print(j.get("title","") or "")')
      _meta_artist=$(printf '%s' "$json" | python3 -c 'import sys,json; j=json.load(sys.stdin); print(j.get("uploader") or j.get("channel") or j.get("uploader_id") or "")')
      _meta_description=$(printf '%s' "$json" | python3 -c 'import sys,json; j=json.load(sys.stdin); print(j.get("description","") or "")')
      date_raw=$(printf '%s' "$json" | python3 -c 'import sys,json; j=json.load(sys.stdin); print(j.get("upload_date") or j.get("release_date") or "")')
    fi
    if [[ "$date_raw" =~ ^[0-9]{8}$ ]]; then
      _meta_date="${date_raw:0:4}-${date_raw:4:2}-${date_raw:6:2}"
    else
      _meta_date="$date_raw"
    fi
  fi
}

# Build tags XML (writes to provided file path). Includes both DESCRIPTION and COMMENT for compatibility.
build_tags_xml() {
  local out="$1"
  local title_cdata artist_cdata desc_cdata date_cdata short_comment
  title_cdata=$(_escape_cdata "$_meta_title")
  artist_cdata=$(_escape_cdata "$_meta_artist")
  desc_cdata=$(_escape_cdata "$_meta_description")
  date_cdata=$(_escape_cdata "$_meta_date")
  # Build a short comment (first 240 chars of description, single-line)
  short_comment=$(printf '%s' "$_meta_description" | tr '\n' ' ' | sed 's/  */ /g' | cut -c1-240)

  {
    cat <<EOF
<?xml version="1.0"?>
<Tags>
  <Tag>
    <Targets></Targets>
EOF
    [[ -n "$title_cdata" ]] && printf '    <Simple>\n      <Name>TITLE</Name>\n      <String><![CDATA[%s]]></String>\n    </Simple>\n' "$title_cdata"
    [[ -n "$artist_cdata" ]] && printf '    <Simple>\n      <Name>ARTIST</Name>\n      <String><![CDATA[%s]]></String>\n    </Simple>\n' "$artist_cdata"
    [[ -n "$desc_cdata" ]] && printf '    <Simple>\n      <Name>DESCRIPTION</Name>\n      <String><![CDATA[%s]]></String>\n    </Simple>\n' "$desc_cdata"
    # Create a COMMENT entry for broader compatibility (short)
    [[ -n "$short_comment" ]] && printf '    <Simple>\n      <Name>COMMENT</Name>\n      <String><![CDATA[%s]]></String>\n    </Simple>\n' "$short_comment"
    [[ -n "$date_cdata" ]] && printf '    <Simple>\n      <Name>DATE_RELEASED</Name>\n      <String><![CDATA[%s]]></String>\n    </Simple>\n' "$date_cdata"
    cat <<EOF
  </Tag>
</Tags>
EOF
  } > "$out"
}

# Try mkvpropedit in-place; return 0 on success, non-zero on failure.
apply_tags_inplace_with_mkvpropedit() {
  local file="$1"
  local tagsfile="$2"
  local title_arg=()
  if [[ -n "$_meta_title" ]]; then
    title_arg=( --edit info --set "title=$_meta_title" )
  fi

  # Build argument array to avoid word splitting
  local args=( "$file" --tags "all:$tagsfile" )
  if [[ ${#title_arg[@]} -gt 0 ]]; then
    args+=( "${title_arg[@]}" )
  fi

  local stderrfile
  stderrfile=$(_mktmp).mkvpropedit.err
  if mkvpropedit "${args[@]}" 2>"$stderrfile"; then
    rm -f "$stderrfile"
    return 0
  else
    echo -e "${warn} mkvpropedit failed; stderr:"
    sed -n '1,200p' "$stderrfile" || true
    rm -f "$stderrfile"
    return 1
  fi
}

# Remux with mkvmerge (stream copy) and include tags; return 0 on success.
remux_with_mkvmerge() {
  local infile="$1"
  local outfile="$2"
  local tagsfile="$3"

  # mkvmerge accepts --title for segment title and --tags for tags file
  # Use a safe command invocation
  if mkvmerge -o "$outfile" --title "$_meta_title" --tags all:"$tagsfile" "$infile" >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

# Remux with ffmpeg (fallback for non-mkv/webm or when mkvmerge not available)
remux_with_ffmpeg() {
  local infile="$1"
  local outfile="$2"
  # map all streams, copy, write metadata
  if ffmpeg -hide_banner -loglevel warning -i "$infile" -map 0 -c copy \
      -metadata title="$_meta_title" \
      -metadata artist="$_meta_artist" \
      -metadata comment="$_meta_description" \
      -metadata date="$_meta_date" \
      "$outfile"; then
    return 0
  else
    return 1
  fi
}

# High-level metadata writer for a single file
process_file() {
  local input_file="$1"
  local filename
  filename="$input_file"

  # Extract YouTube ID (11-char between square brackets)
  local youtube_id
  youtube_id=$(echo "$filename" | grep -oE '\[[A-Za-z0-9_-]{11}\]' | tail -n1 | tr -d '[]') || true

  if [[ -z "$youtube_id" ]]; then
    echo -e "${err} Could not extract YouTube ID from filename: $filename"
    return 1
  fi

  echo -e "${info} Processing: $filename"
  echo -e "${info} YouTube ID: $youtube_id"

  fetch_metadata "$youtube_id"

  echo -e "${info} Title:  ${_meta_title:-<none>}"
  echo -e "${info} Artist: ${_meta_artist:-<none>}"
  echo -e "${info} Date:   ${_meta_date:-<none>}"

  local ext="${filename##*.}"
  local tmp_tags tmp_out

  tmp_tags=$(_mktmp).tags.xml
  build_tags_xml "$tmp_tags"

  # Try mkvpropedit first (works for mkv and often webm)
  if command -v mkvpropedit >/dev/null 2>&1; then
    echo -e "${info} Attempting mkvpropedit in-place..."
    if apply_tags_inplace_with_mkvpropedit "$filename" "$tmp_tags"; then
      echo -e "${succ} MKV/WebM metadata updated in-place (tags + title)."
      rm -f "$tmp_tags"
      return 0
    else
      echo -e "${warn} mkvpropedit could not write in-place; will try remuxing with mkvmerge (preferred) or ffmpeg (fallback)."
    fi
  else
    echo -e "${warn} mkvpropedit not found; will try remuxing."
  fi

  # If mkvpropedit failed (or not present), prefer mkvmerge for remux (avoids ffmpeg Opus warnings)
  if command -v mkvmerge >/dev/null 2>&1; then
    tmp_out=$(_mktmp).out."$ext"
    echo -e "${info} Remuxing with mkvmerge (stream copy) to write tags..."
    if remux_with_mkvmerge "$filename" "$tmp_out" "$tmp_tags"; then
      # preserve perms/timestamps
      chmod --reference="$filename" "$tmp_out" || true
      touch -r "$filename" "$tmp_out" || true
      mv -f "$tmp_out" "$filename"
      rm -f "$tmp_tags"
      echo -e "${succ} Metadata written via mkvmerge remux: $filename"
      return 0
    else
      echo -e "${err} mkvmerge remux failed."
      rm -f "$tmp_out" "$tmp_tags" || true
      # fallthrough to ffmpeg fallback
    fi
  else
    echo -e "${warn} mkvmerge not found; cannot remux with mkvmerge."
  fi

  # Last-resort: ffmpeg remux (for containers mkvmerge doesn't handle or when mkvmerge absent)
  if command -v ffmpeg >/dev/null 2>&1; then
    tmp_out=$(_mktmp).out."$ext"
    echo -e "${info} Remuxing with ffmpeg (stream copy) to write metadata (last resort)..."
    if remux_with_ffmpeg "$filename" "$tmp_out"; then
      chmod --reference="$filename" "$tmp_out" || true
      touch -r "$filename" "$tmp_out" || true
      mv -f "$tmp_out" "$filename"
      rm -f "$tmp_tags"
      echo -e "${succ} Metadata written via ffmpeg remux: $filename"
      return 0
    else
      echo -e "${err} ffmpeg remux failed."
      rm -f "$tmp_out" "$tmp_tags" || true
      return 1
    fi
  else
    echo -e "${err} Neither mkvmerge nor ffmpeg available to remux; cannot write metadata."
    rm -f "$tmp_tags" || true
    return 1
  fi
}

# Main loop
for input_file in *.mkv *.webm *.flv *.avi *.mov *.wmv *.mp4; do
  [[ -f "$input_file" ]] || continue
  process_file "$input_file"
  echo
done