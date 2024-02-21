#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <replacement_color_hex>"
    exit 1
fi

ICONS="./.icons"

# replace color in big logo
file_path="foundry:/home/foundry/resources/app/public/icons/vtt-512.png"
large_path=$(../.scripts/save_copy.sh get "$file_path" "$ICONS")
../.scripts/replace_color.py "$large_path" "$1" "$large_path"
../.scripts/save_copy.sh set "$file_path" "$ICONS"

# resize to smaller size
file_path="foundry:/home/foundry/resources/app/public/icons/vtt.png"
small_path=$(../.scripts/save_copy.sh get "$file_path" "$ICONS")
convert "$large_path" -resize "32x32" "$small_path"
../.scripts/save_copy.sh set "$file_path" "$ICONS"

# replace color in anvil logo
file_path="foundry:/home/foundry/resources/app/public/icons/fvtt.png"
fvtt_path=$(../.scripts/save_copy.sh get "$file_path" "$ICONS")
composite -geometry +28+1  "$small_path" "$fvtt_path" "$fvtt_path"
../.scripts/save_copy.sh set "$file_path" "$ICONS"
