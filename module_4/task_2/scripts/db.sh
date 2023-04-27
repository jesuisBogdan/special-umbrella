#!/bin/bash

DB_FILE=./data/users.db

BACKUPS_DIR=./data/backups

function validateInput {
    local input=$1
    if ! [[ "$input" =~ ^[a-zA-Z]+$ ]]; then
        echo "Error: $input is not a valid input. Only Latin letters are allowed."
        exit 1
    fi
}

function createDbFile {
    echo "The users.db file does not exist."
    read -p "Do you want to create it? (y/n) " choice
    case "$choice" in
        [Yy]*)
            mkdir -p ./data
            touch $DB_FILE
            echo "Created $DB_FILE."
            ;;
        [Nn]*)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid choice. Exiting."
            exit 1
            ;;
    esac
}

if [ ! -f $DB_FILE ]; then
    createDbFile
fi

function add {
    read -p "Enter username: " username
    validate_input $username
    read -p "Enter role: " role
    validate_input $role
    echo "$username, $role" >> $DB_FILE
    echo "Added new entity to $DB_FILE: $username, $role"
}

function backup {
    local timestamp=$(date +%Y-%m-%d-%H-%M-%S)
    local backup_file="$BACKUPS_DIR/$timestamp-users.db.backup"
    cp $DB_FILE $backup_file
    echo "Created backup file: $backup_file"
}

function restore {
    local latest_backup=$(ls -1tr $BACKUPS_DIR/*.backup | tail -n 1)
    if [ -z "$latest_backup" ]; then
        echo "No backup file found."
    else
        cp $latest_backup $DB_FILE
        echo "Restored database from backup file: $latest_backup"
    fi
}

function findEntity {
    read -p "Enter username to search for: " query
    validate_input $query
    local results=$(grep -i "^$query," $DB_FILE)
    if [ -z "$results" ]; then
        echo "User not found"
    else
        echo "$results"
    fi
}

function listEntities {
    local count=0
    if [ "$1" == "--inverse" ]; then
        tac $DB_FILE | while IFS= read -r line; do
            (( count++ ))
            echo "$count. $line"
        done
    else
        while IFS= read -r line; do
            (( count++ ))
            echo "$count. $line"
        done < $DB_FILE
    fi
}

case "$1" in
    "add")
        add
        ;;
    "backup")
        backup
        ;;
    "restore")
        restore
        ;;
    "find")
        find_entity
        ;;
    "list")
        if [ "$2" == "--inverse" ]; then
            list_entities --inverse
        else
            list_entities
        fi
        ;;
    ""|"help")
        echo "Usage: $0 COMMAND"
        echo "Available commands:"
        echo "  add      Adds a new entity to $DB_FILE"
        echo "  backup   Creates a backup of $DB_FILE"
        echo "  restore  Restores $DB_FILE from the latest backup"
        echo "  find     Searches $DB_FILE for entities by username"
        echo "  list     Lists all entities in $DB_FILE"
        echo "           --inverse  Lists all entities in reverse order"
        ;;
    *)
        echo "Invalid command. Type '$0 help' for usage."
        exit 1
        ;;
esac
