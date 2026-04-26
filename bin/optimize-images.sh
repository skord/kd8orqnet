#!/usr/bin/env bash
# Resize and recompress photos under assets/images/photos/ for web delivery.
# Originals are copied to _photo-originals/ (gitignored) before the first edit,
# so optimization is reversible. Idempotent on re-runs.

set -euo pipefail

MAX_EDGE=1600
QUALITY=82
MAX_BYTES=$((500 * 1024))
TARGET_BYTES=$((480 * 1024))
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PHOTOS_DIR="$ROOT/assets/images/photos"
ORIGINALS_DIR="$ROOT/_photo-originals"
TARGET_DIR="${1:-$PHOTOS_DIR}"

if ! command -v magick >/dev/null 2>&1; then
  echo "error: ImageMagick (magick) not found in PATH" >&2
  exit 1
fi

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "error: directory not found: $TARGET_DIR" >&2
  exit 1
fi

processed=0
skipped=0

while IFS= read -r -d '' img; do
  read -r w h < <(magick identify -format '%w %h\n' "$img" 2>/dev/null || echo "0 0")
  bytes=$(stat -c%s "$img")
  longest=$(( w > h ? w : h ))
  ext_lc="${img##*.}"
  ext_lc="${ext_lc,,}"

  # PNGs: only enforce dimensions (size depends on content; can't always shrink further)
  # JPEGs: enforce both dimensions and byte budget
  if [[ "$ext_lc" == "png" ]]; then
    if (( longest <= MAX_EDGE )); then
      skipped=$((skipped + 1))
      continue
    fi
  else
    if (( longest <= MAX_EDGE && bytes <= MAX_BYTES )); then
      skipped=$((skipped + 1))
      continue
    fi
  fi

  echo "optimizing: ${img#$ROOT/} (${w}x${h}, $((bytes / 1024))KB)"

  # Preserve full-resolution original (idempotent: only copy if not already present)
  if [[ "$img" == "$PHOTOS_DIR/"* ]]; then
    rel="${img#$PHOTOS_DIR/}"
    orig_path="$ORIGINALS_DIR/$rel"
    if [[ ! -f "$orig_path" ]]; then
      mkdir -p "$(dirname "$orig_path")"
      cp -p "$img" "$orig_path"
      echo "  preserved original: ${orig_path#$ROOT/}"
    fi
  fi

  ext="${img##*.}"
  ext_lc="${ext,,}"
  tmp="${img}.optimized.${ext}"

  if [[ "$ext_lc" == "png" ]]; then
    magick "$img" \
      -auto-orient \
      -resize "${MAX_EDGE}x${MAX_EDGE}>" \
      -strip \
      -define png:compression-level=9 \
      "$tmp"
  else
    magick "$img" \
      -auto-orient \
      -resize "${MAX_EDGE}x${MAX_EDGE}>" \
      -strip \
      -interlace Plane \
      -sampling-factor 4:2:0 \
      -quality "$QUALITY" \
      -unsharp 0x0.75+0.75+0.008 \
      -define "jpeg:extent=$((TARGET_BYTES / 1024))kb" \
      "$tmp"
  fi

  new_bytes=$(stat -c%s "$tmp")
  if (( new_bytes < bytes )); then
    mv "$tmp" "$img"
    echo "  -> $((new_bytes / 1024))KB"
    processed=$((processed + 1))
  else
    rm -f "$tmp"
    echo "  -> kept original ($((new_bytes / 1024))KB re-encode was not smaller)"
    skipped=$((skipped + 1))
  fi
done < <(find "$TARGET_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -print0)

echo "done: $processed optimized, $skipped already optimal"
