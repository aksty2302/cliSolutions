#!/bin/bash

# Define source and destination directories
SOURCE_DIR="source"
DEST_DIR="destination"

# Function to display identical files in source and destination
show_identical_files() {
    echo "Identical files in source and destination:"
    comm -12 \
        <(cd "$SOURCE_DIR" && find . -type f -exec md5sum {} + | sort -k 2) \
        <(cd "$DEST_DIR" && find . -type f -exec md5sum {} + | sort -k 2) \
        | cut -d ' ' -f 3-
}

# Function to copy non-identical files from source to destination
copy_files() {
    rsync -av --ignore-existing --progress "$SOURCE_DIR/" "$DEST_DIR/"
    echo "Copied non-identical files from source to destination."
}

# Function to move all files from source to destination
move_files() {
    mv -v "$SOURCE_DIR/"* "$DEST_DIR/"
    echo "Moved all files from source to destination."
}

# Function to copy files by extension
copy_files_by_extension() {
    local extension="$1"
    rsync -av --include="*/" --include="*.$extension" --exclude="*" "$SOURCE_DIR/" "$DEST_DIR/"
    echo "Copied all .$extension files from source to destination."
}

# Function to perform a bidirectional backup
perform_backup() {
    rsync -av --ignore-existing "$SOURCE_DIR/" "$DEST_DIR/"
    rsync -av --ignore-existing "$DEST_DIR/" "$SOURCE_DIR/"
    rsync -av --update "$SOURCE_DIR/" "$DEST_DIR/"
    echo "Backup completed successfully."
}

# Main script logic
main() {
    if [ $# -eq 0 ]; then
        show_identical_files
        exit 0
    fi

    case "$1" in
        "copy")
            if [ $# -eq 1 ]; then
                copy_files
            elif [ $# -eq 2 ]; then
                copy_files_by_extension "$2"
            else
                echo "Invalid usage. Usage: $0 copy [extension]"
            fi
            ;;
        "move")
            move_files
            ;;
        "backup")
            perform_backup
            ;;
        *)
            echo "Invalid command. Available commands: copy, move, backup"
            exit 1
            ;;
    esac
}

# Run the script
main "$@"
echo "2023EB03181"