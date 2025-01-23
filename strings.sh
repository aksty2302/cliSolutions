#!/bin/bash

# File to process
FILE="paragraph.txt"

# Function to replace a word in the file
replace_word() {
    local search_word="$1"
    local replace_word="$2"
    if [[ -z "$search_word" || -z "$replace_word" ]]; then
        echo "Error: Both search and replace words must be provided."
        exit 1
    fi
    sed -i "s/\b$search_word\b/$replace_word/g" "$FILE"
    echo "Replaced '$search_word' with '$replace_word' in $FILE."
}

# Function to count words in the file
count_words() {
    wc -w < "$FILE"
}

# Function to count lines in the file
count_lines() {
    wc -l < "$FILE"
}

# Function to lookup occurrences of a specific word
lookup_word() {
    local word="$1"
    if [[ -z "$word" ]]; then
        echo "Error: A word to lookup must be provided."
        exit 1
    fi
    grep -o -w "$word" "$FILE" | wc -l
}

# Main script logic
main() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: $0 <command> [args...]"
        echo "Commands:"
        echo "  words                  Count the number of words in the file."
        echo "  lines                  Count the number of lines in the file."
        echo "  lookup <word>          Count occurrences of a specific word."
        echo "  replace <old> <new>    Replace a word in the file."
        exit 1
    fi

    case "$1" in
        "words")
            echo "Total words in $FILE: $(count_words)"
            ;;
        "lines")
            echo "Total lines in $FILE: $(count_lines)"
            ;;
        "lookup")
            if [[ $# -lt 2 ]]; then
                echo "Error: Missing word to lookup."
                exit 1
            fi
            echo "Occurrences of '$2' in $FILE: $(lookup_word "$2")"
            ;;
        "replace")
            if [[ $# -lt 3 ]]; then
                echo "Error: Missing search or replace word."
                exit 1
            fi
            replace_word "$2" "$3"
            ;;
        *)
            echo "Error: Unknown command '$1'."
            exit 1
            ;;
    esac
}

# Run the script
main "$@"
echo "2023eb03181"