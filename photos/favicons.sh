#!/bin/bash

# Check if a color is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <replacement_color_hex>"
    exit 1
fi


replacement_color_hex=$1
file_list="favicons.txt" # The file containing the list of image paths in the Docker container
resize_list="resize.txt" # The file containing the list of image paths for resizing
FAVICONS="./.favicons" # Folder to store processed images and backups


# Read the file line by line
while IFS= read -r line; do
    echo "Processing $line..."
    file_path="immich-server:$line"
    target_path=$(../.scripts/save_copy.sh get "$file_path" "$FAVICONS")
    ../.scripts/replace_color.py "$target_path" "$replacement_color_hex" "$target_path"
    ../.scripts/save_copy.sh set "$file_path" "$FAVICONS"
    echo "Processed and copied back $line"
done < "$file_list"

# Resize favicon.png according to resize.txt instructions
while IFS= read -r line; do
    echo "Resizing and processing $line..."
    file_path="immich-server:$line"
    size=$(echo "$line" | grep -o '[0-9]\+')
    target_path=$(../.scripts/save_copy.sh get "$file_path" "$FAVICONS")
    convert "$FAVICONS/favicon.png" -resize "${size}x${size}" "$target_path"
    ../.scripts/save_copy.sh set "$file_path" "$FAVICONS"
    echo "Resized and processed $line"
done < "$resize_list"


echo "Creating favicon.ico"
file_path='immich-server:/usr/src/app/www/favicon.ico'
target_path=$(../.scripts/save_copy.sh get "$file_path" "$FAVICONS")
convert "$FAVICONS/favicon.png" -resize 256x256 -define icon:auto-resize=64,48,32,16 "$target_path"
../.scripts/save_copy.sh set "$file_path" "$FAVICONS"
echo "Created favicon.ico"

echo "All files processed and resized as requested."
