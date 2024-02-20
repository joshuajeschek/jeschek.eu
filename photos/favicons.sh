#!/bin/bash

# Check if a color is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <replacement_color_hex>"
    exit 1
fi


replacement_color_hex=$1
file_list="favicons.txt" # The file containing the list of image paths in the Docker container
resize_list="resize.txt" # The file containing the list of image paths for resizing
favicons_folder="./.favicons" # Folder to store processed images and backups

# Create the favicons directory if it doesn't exist
mkdir -p "$favicons_folder"

# Read the file line by line
while IFS= read -r line; do
    echo "Processing $line..."
    file_name=$(basename "$line")
    target_path="$favicons_folder/$file_name"
    backup_path="$target_path.bak"

    # Copy file from Docker container to the .favicons folder
    docker compose cp "immich-server:$line" "$target_path"

    # Create a backup copy with .bak extension
    if [ ! -f "$backup_path" ]; then
        echo "Creating backup for $line..."
        cp "$target_path" "$backup_path"
    else
        echo "Backup already exists for $line, skipping backup creation."
    fi

    # Apply the Python script
    ./replace_color.py "$target_path" "$replacement_color_hex" "$target_path"

    # Copy the modified file back to the container
    docker compose cp "$target_path" "immich-server:$line"

    echo "Processed and copied back $line"
done < "$file_list"

# Resize favicon.png according to resize.txt instructions
while IFS= read -r line; do
    echo "Resizing and processing $line..."
    file_name=$(basename "$line")

    # Extract size from the file path
    size=$(echo "$line" | grep -o '[0-9]\+')
    target_path="$favicons_folder/$file_name"
    backup_path="$target_path.bak"

    docker compose -p photos cp "immich-server:$line" "$target_path"

    # Create a backup copy with .bak extension
    if [ ! -f "$backup_path" ]; then
        echo "Creating backup for $line..."
        cp "$target_path" "$backup_path"
    else
        echo "Backup already exists for $line, skipping backup creation."
    fi

    # Resize favicon.png to the specified size and save to target path
    convert "$favicons_folder/favicon.png" -resize "${size}x${size}" "$target_path"

    docker compose -p photos cp "$target_path" "immich-server:$line"

    echo "Resized and processed $line"
done < "$resize_list"

echo "All files processed and resized as requested."
