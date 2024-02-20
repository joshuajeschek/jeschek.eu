#!/bin/bash

# Check if color argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <color>"
    exit 1
fi

NEW_COLOR=$1

mkdir -p .icons

while IFS= read -r line; do
    FILENAME=$(basename "$line")
    docker compose cp app:"$line" ".icons/$FILENAME"
    cp ".icons/$FILENAME" ".icons/$FILENAME.bak"
    sed -i "s/fill=\"[^\"]*\"/fill=\"$NEW_COLOR\"/g" ".icons/$FILENAME"
    docker compose cp ".icons/$FILENAME" app:"$line"
done < icons.txt

