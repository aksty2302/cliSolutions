#!/bin/bash

# Input file containing the paragraph
INPUT_FILE="paragraph.txt"

# Extract words starting with a vowel and save to beginning.txt
extract_words_starting_with_vowel() {
    grep -o -E '\b[AEIOUaeiou][a-zA-Z]*\b' "$INPUT_FILE" > beginning.txt
    echo "Words starting with a vowel have been saved to beginning.txt."
}

# Extract words ending with a vowel and save to ending.txt
extract_words_ending_with_vowel() {
    grep -o -E '\b[a-zA-Z]*[AEIOUaeiou]\b' "$INPUT_FILE" > ending.txt
    echo "Words ending with a vowel have been saved to ending.txt."
}

# Display words that begin and end with the same letter (case-insensitive)
display_words_same_start_end() {
    echo "Words that begin and end with the same letter (case-insensitive):"
    grep -o -E '\b([a-zA-Z])([a-zA-Z]*)(\1)\b' "$INPUT_FILE" \
        | awk '{print tolower($0)}' \
        | uniq
}

# Main script logic
main() {
    extract_words_starting_with_vowel
    extract_words_ending_with_vowel
    display_words_same_start_end
}

# Run the script
main
echo "2023eb03181"
