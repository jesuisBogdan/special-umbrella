#!/bin/bash

# Set the default threshold value to 10%
THRESHOLD=10

# Check if a threshold value was provided as a command line argument
if [ $# -gt 0 ]; then
    THRESHOLD=$1
fi

# Print the initial disk space
echo "Initial Disk Space:"
df -h

# Infinite loop to check the disk space
while true; do
    # Get the current disk space
    SPACE_AVAILABLE=$(df -P / --block-size=1 | tail -1 | awk '{print $4}')

    echo "SPACE_AVAILABLE: $(numfmt --to=iec $SPACE_AVAILABLE)"

    # Check if the disk space has dropped below the threshold
    if [ $SPACE_AVAILABLE -lt $THRESHOLD ]; then
        # Alert the user
        echo "WARNING: Disk space has dropped below $THRESHOLD%"

        # Wait for user input before continuing
        read -p "Press any key to continue..."
    fi

    # Wait for 5 seconds before checking again
    sleep 5
done
