#!/bin/bash

# File to store all emails
EMAILS_FILE="emails.txt"

# File to store valid emails
VALID_EMAILS_FILE="valid_emails.txt"

# Display the menu options
display_menu() {
    echo "Email Management System"
    echo "-----------------------"
    echo "1. Add an email"
    echo "2. Extract valid emails"
    echo "3. Exit"
    echo -n "Enter your choice (1-3): "
}

# Add an email to the emails file
add_email() {
    echo -n "Enter email: "
    read email
    echo "$email" >> "$EMAILS_FILE"
    echo "Email added successfully!"
}

# Validate emails and save valid ones to a separate file
extract_valid_emails() {
    local regex="^[a-zA-Z0-9]+@[a-zA-Z]+\.com$"
    > "$VALID_EMAILS_FILE"  # Clear the valid emails file

    if [[ ! -f "$EMAILS_FILE" ]]; then
        echo "No emails found. Please add emails first."
        return
    fi

    while IFS= read -r email; do
        if [[ $email =~ $regex ]]; then
            echo "$email" >> "$VALID_EMAILS_FILE"
        fi
    done < "$EMAILS_FILE"

    if [[ -s "$VALID_EMAILS_FILE" ]]; then
        echo "Valid emails have been saved to $VALID_EMAILS_FILE."
    else
        echo "No valid emails found."
    fi
}

# Main program logic
main() {
    while true; do
        display_menu
        read choice
        case $choice in
            1) add_email ;;
            2) extract_valid_emails ;;
            3) echo "Exiting..."; exit 0 ;;
            *) echo "Invalid option. Please try again." ;;
        esac
        echo
    done
}

# Run the program
main
echo "2023EB03181"