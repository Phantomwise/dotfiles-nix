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

#
# Merge helpers
#

# Merge two Matroska tags XML files (existing + new). New values win on conflict.
# Usage: merge_mkv_tag_files existing.xml new.xml out.xml
# If existing.xml is empty or missing, result == new.xml
merge_mkv_tag_files() {
  local existing="$1" new="$2" out="$3"

  # If no existing tags file, just copy new -> out
  if [[ ! -s "$existing" ]]; then
    cp -f "$new" "$out"
    return 0
  fi

  # Use python to parse and merge while preserving separate Tag blocks (Targets)
  python3 - "$existing" "$new" "$out" <<'PY'
import sys, xml.etree.ElementTree as ET, html

existing_path, new_path, out_path = sys.argv[1:4]

def load_tag_list(p):
    try:
        tree = ET.parse(p)
    except Exception:
        return []
    root = tree.getroot()
    tags = []
    for tag in root.findall('Tag'):
        # targets: list of (tagname, text)
        targets_el = tag.find('Targets')
        targets = []
        if targets_el is not None:
            for child in list(targets_el):
                targets.append((child.tag, child.text or ''))
        # simples: list of (name, value, taglang)
        simples = []
        for simple in tag.findall('Simple'):
            name_el = simple.find('Name')
            string_el = simple.find('String')
            taglang_el = simple.find('TagLanguageIETF')
            name = (name_el.text or '') if name_el is not None else ''
            # collect text content of String (collapse possible nested text)
            val = ''
            if string_el is not None:
                val = ''.join(string_el.itertext())
            taglang = taglang_el.text if taglang_el is not None else None
            if name:
                simples.append((name, val, taglang))
        tags.append({'targets': targets, 'simples': simples})
    return tags

existing_tags = load_tag_list(existing_path)
new_tags = load_tag_list(new_path)

# collect new simple entries from new_tags; prefer the ones in the global tag of new, but also consider all new Simple entries
new_map = {}
for t in new_tags:
    for name, val, taglang in t['simples']:
        new_map[name] = (val, taglang)

# find global tag in existing (first Tag with empty targets)
global_index = None
for i, t in enumerate(existing_tags):
    if not t['targets']:  # empty targets -> global
        global_index = i
        break

if global_index is None:
    # create a new global tag at the top
    existing_tags.insert(0, {'targets': [], 'simples': []})
    global_index = 0

# build a map of existing global simples, then update with new_map (new wins)
existing_global = {}
for name, val, taglang in existing_tags[global_index]['simples']:
    existing_global[name] = (val, taglang)

# merge (new overrides)
for name, (val, taglang) in new_map.items():
    existing_global[name] = (val, taglang)

# convert back to list preserving original order for names present, and append new keys
merged_simples = []
# preserve order: first existing order (replaced values), then any new keys not present before
seen = set()
for name, val, taglang in existing_tags[global_index]['simples']:
    merged_simples.append((name, existing_global[name][0], existing_global[name][1]))
    seen.add(name)
for name in new_map:
    if name not in seen:
        merged_simples.append((name, existing_global[name][0], existing_global[name][1]))

existing_tags[global_index]['simples'] = merged_simples

# write output using CDATA for String values (escape any internal ']]>' sequences)
def escape_cdata(s):
    if s is None:
        return ''
    return s.replace(']]>', ']]]]><![CDATA[>')

with open(out_path, 'w', encoding='utf-8') as f:
    f.write('<?xml version="1.0"?>\n')
    f.write('<Tags>\n')
    for tag in existing_tags:
        f.write('  <Tag>\n')
        if not tag['targets']:
            f.write('    <Targets />\n')
        else:
            f.write('    <Targets>\n')
            for tname, tval in tag['targets']:
                # tval may be None or empty
                txt = tval or ''
                # escape ampersand/lt/gt in target text
                f.write('      <{0}>{1}</{0}>\n'.format(tname, html.escape(txt)))
            f.write('    </Targets>\n')
        for name, val, taglang in tag['simples']:
            f.write('    <Simple>\n')
            f.write('      <Name>{}</Name>\n'.format(html.escape(name)))
            v = escape_cdata(val or '')
            f.write('      <String><![CDATA[{}]]></String>\n'.format(v))
            if taglang:
                f.write('      <TagLanguageIETF>{}</TagLanguageIETF>\n'.format(html.escape(taglang)))
            f.write('    </Simple>\n')
        f.write('  </Tag>\n')
    f.write('</Tags>\n')
PY
}

# Merge ffprobe format tags (existing JSON) with new metadata values.
# Writes a simple key=value per line (shell-escaped as UTF-8) to out_kv file.
# Usage: merge_ffmpeg_metadata existing_ffprobe_json new_kv_json out_kv
# existing_ffprobe_json may be empty or non-existent (treated as empty)
merge_ffmpeg_metadata() {
  local existing_json="$1" new_json="$2" out_kv="$3"

  if [[ ! -s "$existing_json" ]]; then
    # just convert new_json to key=value lines
    python3 - "$new_json" "$out_kv" <<'PY'
import sys, json, shlex
newp = sys.argv[1]
outp = sys.argv[2]
with open(newp, 'r', encoding='utf-8') as f:
    new = json.load(f) if f.readable() else {}
# new is expected to be a dict
if not isinstance(new, dict):
    new = {}
with open(outp, 'w', encoding='utf-8') as out:
    for k, v in new.items():
        if v is None:
            continue
        # Ensure no newlines in values; ffmpeg metadata entries should be single-line
        val = str(v).replace('\n', ' ')
        out.write(f"{k}={val}\n")
PY
    return 0
  fi

  python3 - "$existing_json" "$new_json" "$out_kv" <<'PY'
import sys, json
existing_p = sys.argv[1]
new_p = sys.argv[2]
out_p = sys.argv[3]

try:
    with open(existing_p, 'r', encoding='utf-8') as f:
        ex = json.load(f)
except Exception:
    ex = {}

# ffprobe JSON format: { "format": { "tags": { ... } } }
ex_tags = {}
if isinstance(ex, dict):
    fmt = ex.get('format') or {}
    ex_tags = fmt.get('tags') or {}

try:
    with open(new_p, 'r', encoding='utf-8') as f:
        new = json.load(f)
except Exception:
    new = {}

# new expected as dict
if not isinstance(new, dict):
    new = {}

# merge (new overrides)
merged = ex_tags.copy()
merged.update(new)

with open(out_p, 'w', encoding='utf-8') as out:
    for k, v in merged.items():
        if v is None:
            continue
        val = str(v).replace('\n', ' ')
        out.write(f"{k}={val}\n")
PY
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
# Accepts optional metadata kv-file path as third arg (key=value per line)
remux_with_ffmpeg() {
  local infile="$1"
  local outfile="$2"
  local kvfile="${3:-}"

  # Build metadata args if kvfile provided
  local meta_args=()
  if [[ -n "$kvfile" && -s "$kvfile" ]]; then
    while IFS= read -r line || [[ -n "$line" ]]; do
      # skip empty lines
      [[ -z "$line" ]] && continue
      # split at first '='
      local key="${line%%=*}"
      local val="${line#*=}"
      # ffmpeg expects -metadata key=value; ensure proper quoting by using bash arrays
      meta_args+=( -metadata "${key}=${val}" )
    done < "$kvfile"
  else
    # fallback to previous limited metadata set
    [[ -n "$_meta_title" ]] && meta_args+=( -metadata title="$_meta_title" )
    [[ -n "$_meta_artist" ]] && meta_args+=( -metadata artist="$_meta_artist" )
    [[ -n "$_meta_description" ]] && meta_args+=( -metadata comment="$_meta_description" )
    [[ -n "$_meta_date" ]] && meta_args+=( -metadata date="$_meta_date" )
  fi

  if ffmpeg -hide_banner -loglevel warning -i "$infile" -map 0 -c copy "${meta_args[@]}" "$outfile"; then
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
  local tmp_existing tmp_merged tmp_meta_kv tmp_existing_ffprobe tmp_newmeta_json

  tmp_tags=$(_mktmp).tags.xml
  build_tags_xml "$tmp_tags"

  #
  # If Matroska (mkv/webm): try to extract existing tags and merge XML files so we don't lose previous keys
  #
  if [[ "$ext" =~ ^(mkv|webm)$ ]]; then
    tmp_existing=$(_mktmp).existing.tags.xml
    tmp_merged=$(_mktmp).merged.tags.xml

    if command -v mkvextract >/dev/null 2>&1; then
      # Attempt extraction; if it fails, we'll fallback to replacing tags
      if mkvextract tags "$filename" "$tmp_existing" >/dev/null 2>&1; then
        echo -e "${info} Existing Matroska tags extracted; merging with new tags (new wins)..."
      else
        # cleanup and treat as no existing tags
        rm -f "$tmp_existing" || true
        touch "$tmp_existing" || true
        echo -e "${warn} Could not extract existing tags; will replace tags."
      fi
    else
      echo -e "${warn} mkvextract not found; cannot merge existing Matroska tags. New tags will replace old ones."
      # ensure tmp_existing is empty
      : > "$tmp_existing"
    fi

    # Merge existing and new (new wins)
    merge_mkv_tag_files "$tmp_existing" "$tmp_tags" "$tmp_merged" || {
      echo -e "${warn} Tag merging failed; will use new tags only."
      cp -f "$tmp_tags" "$tmp_merged" || true
    }

    # Try mkvpropedit first
    if command -v mkvpropedit >/dev/null 2>&1; then
      echo -e "${info} Attempting mkvpropedit in-place with merged tags..."
      if apply_tags_inplace_with_mkvpropedit "$filename" "$tmp_merged"; then
        echo -e "${succ} MKV/WebM metadata updated in-place (merged tags + title)."
        rm -f "$tmp_tags" "$tmp_existing" "$tmp_merged" || true
        return 0
      else
        echo -e "${warn} mkvpropedit could not write in-place; will try remuxing with mkvmerge (preferred) or ffmpeg (fallback)."
      fi
    else
      echo -e "${warn} mkvpropedit not found; will try remuxing."
    fi

    # If mkvmerge available, remux with merged tags
    if command -v mkvmerge >/dev/null 2>&1; then
      tmp_out=$(_mktmp).out."$ext"
      echo -e "${info} Remuxing with mkvmerge (stream copy) to write merged tags..."
      if remux_with_mkvmerge "$filename" "$tmp_out" "$tmp_merged"; then
        chmod --reference="$filename" "$tmp_out" || true
        touch -r "$filename" "$tmp_out" || true
        mv -f "$tmp_out" "$filename"
        rm -f "$tmp_tags" "$tmp_existing" "$tmp_merged"
        echo -e "${succ} Metadata written via mkvmerge remux (merged tags): $filename"
        return 0
      else
        echo -e "${err} mkvmerge remux failed."
        rm -f "$tmp_out" "$tmp_tags" "$tmp_existing" "$tmp_merged" || true
        # fallthrough to ffmpeg fallback below
      fi
    else
      echo -e "${warn} mkvmerge not found; cannot remux with mkvmerge."
    fi

    # Last-resort ffmpeg remux for Matroska (will attempt to merge ffmpeg-format tags if possible)
    if command -v ffmpeg >/dev/null 2>&1; then
      echo -e "${info} Falling back to ffmpeg remux for Matroska. Will attempt to preserve existing non-matroska-format tags if possible..."
      # For ffmpeg path we attempt to extract existing format tags via ffprobe and merge with our keys
      tmp_existing_ffprobe=$(_mktmp).existing.ffprobe.json
      tmp_newmeta_json=$(_mktmp).newmeta.json
      tmp_meta_kv=$(_mktmp).merged_meta.kv

      # Prepare new metadata JSON for ffmpeg merging (keys similar to what we write)
      python3 - "$tmp_newmeta_json" <<'PY'
import sys, json
out = sys.argv[1]
d = {}
# set only non-empty values
import os
title = os.environ.get("_META_TITLE","")
artist = os.environ.get("_META_ARTIST","")
desc = os.environ.get("_META_DESC","")
date = os.environ.get("_META_DATE","")
if title: d["title"] = title
if artist: d["artist"] = artist
if desc: d["comment"] = desc
if date: d["date"] = date
with open(out, "w", encoding="utf-8") as f:
    json.dump(d, f)
PY
      # Pass metadata to python via env
      export _META_TITLE="${_meta_title:-}"
      export _META_ARTIST="${_meta_artist:-}"
      export _META_DESC="${_meta_description:-}"
      export _META_DATE="${_meta_date:-}"

      if command -v ffprobe >/dev/null 2>&1; then
        ffprobe -v quiet -print_format json -show_format "$filename" > "$tmp_existing_ffprobe" || true
      else
        : > "$tmp_existing_ffprobe"
      fi

      # Merge to kv file
      merge_ffmpeg_metadata "$tmp_existing_ffprobe" "$tmp_newmeta_json" "$tmp_meta_kv" || true

      tmp_out=$(_mktmp).out."$ext"
      if remux_with_ffmpeg "$filename" "$tmp_out" "$tmp_meta_kv"; then
        chmod --reference="$filename" "$tmp_out" || true
        touch -r "$filename" "$tmp_out" || true
        mv -f "$tmp_out" "$filename"
        rm -f "$tmp_tags" "$tmp_existing" "$tmp_merged" "$tmp_existing_ffprobe" "$tmp_newmeta_json" "$tmp_meta_kv" || true
        echo -e "${succ} Metadata written via ffmpeg remux (merged where possible): $filename"
        return 0
      else
        echo -e "${err} ffmpeg remux failed."
        rm -f "$tmp_out" "$tmp_tags" "$tmp_existing" "$tmp_merged" "$tmp_existing_ffprobe" "$tmp_newmeta_json" "$tmp_meta_kv" || true
        return 1
      fi
    else
      echo -e "${err} Neither mkvmerge nor ffmpeg available to remux; cannot write metadata."
      rm -f "$tmp_tags" "$tmp_existing" "$tmp_merged" || true
      return 1
    fi
  fi

  #
  # Non-Matroska path: attempt to preserve existing ffmpeg/format tags via ffprobe
  #
  # Build newmeta JSON for merging with existing tags found by ffprobe
  tmp_existing_ffprobe=$(_mktmp).existing.ffprobe.json
  tmp_newmeta_json=$(_mktmp).newmeta.json
  tmp_meta_kv=$(_mktmp).merged_meta.kv

  python3 - "$tmp_newmeta_json" <<'PY'
import sys, json, os
out = sys.argv[1]
d = {}
title = os.environ.get("_META_TITLE","")
artist = os.environ.get("_META_ARTIST","")
desc = os.environ.get("_META_DESC","")
date = os.environ.get("_META_DATE","")
if title: d["title"] = title
if artist: d["artist"] = artist
if desc: d["comment"] = desc
if date: d["date"] = date
with open(out, "w", encoding="utf-8") as f:
    json.dump(d, f)
PY
  export _META_TITLE="${_meta_title:-}"
  export _META_ARTIST="${_meta_artist:-}"
  export _META_DESC="${_meta_description:-}"
  export _META_DATE="${_meta_date:-}"

  if command -v ffprobe >/dev/null 2>&1; then
    ffprobe -v quiet -print_format json -show_format "$filename" > "$tmp_existing_ffprobe" || true
  else
    : > "$tmp_existing_ffprobe"
  fi

  # Merge existing ffprobe tags with our new tags (new wins)
  merge_ffmpeg_metadata "$tmp_existing_ffprobe" "$tmp_newmeta_json" "$tmp_meta_kv" || {
    # fallback: just use our new minimal metadata
    : > "$tmp_meta_kv"
  }

  # Use mkvmerge/ffmpeg depending on availability: prefer mkvmerge only for mkv/webm earlier; here we will use ffmpeg
  if command -v ffmpeg >/dev/null 2>&1; then
    tmp_out=$(_mktmp).out."$ext"
    echo -e "${info} Remuxing with ffmpeg (stream copy) to write metadata (merged where possible)..."
    if remux_with_ffmpeg "$filename" "$tmp_out" "$tmp_meta_kv"; then
      chmod --reference="$filename" "$tmp_out" || true
      touch -r "$filename" "$tmp_out" || true
      mv -f "$tmp_out" "$filename"
      rm -f "$tmp_tags" "$tmp_existing_ffprobe" "$tmp_newmeta_json" "$tmp_meta_kv" || true
      echo -e "${succ} Metadata written via ffmpeg remux (merged where possible): $filename"
      return 0
    else
      echo -e "${err} ffmpeg remux failed."
      rm -f "$tmp_out" "$tmp_tags" "$tmp_existing_ffprobe" "$tmp_newmeta_json" "$tmp_meta_kv" || true
      return 1
    fi
  else
    echo -e "${err} ffmpeg not available to remux; cannot write metadata for non-matroska file."
    rm -f "$tmp_tags" "$tmp_existing_ffprobe" "$tmp_newmeta_json" "$tmp_meta_kv" || true
    return 1
  fi
}

# Main loop
for input_file in *.mkv *.webm *.flv *.avi *.mov *.wmv *.mp4; do
  [[ -f "$input_file" ]] || continue
  process_file "$input_file"
  echo
done