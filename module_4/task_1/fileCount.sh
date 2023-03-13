#!/bin/bash

# Check if any directory path was provided as a command line argument
if [ $# -eq 0 ]; then
    echo "Error: Please provide at least one directory path as a command line argument."
    exit 1
fi

# Loop through each directory path provided as a command line argument
for DIR in "$@"; do
    # Check if the directory path exists
    if [ ! -d "$DIR" ]; then
        echo "Error: $DIR is not a valid directory path."
        continue
    fi

    # Count the number of files in the directory and its subdirectories
    FILE_COUNT=$(find "$DIR" -type f | wc -l)

    # Print the directory path and the number of files
    echo "$DIR: $FILE_COUNT"
done