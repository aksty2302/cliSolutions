#!/bin/bash

# Check the number of arguments
if [ $# -eq 0 ]; then
    # If no arguments are provided, calculate and print the total price for each fruit
    awk '{ total_price = $3 * $4; print $1, total_price }' fruits.txt
elif [ $# -eq 1 ]; then
    # If one argument is provided, determine its type and process accordingly
    if [[ $1 =~ ^[A-Za-z]$ ]]; then
        # If the argument is a single letter (assumed to be a vitamin)
        awk -v vit="$1" '$2 == vit { total_price += $3 * $4; print $1 } END { print total_price }' fruits.txt
    elif [[ $1 =~ ^[0-9]+$ ]]; then
        # If the argument is a number (assumed to be a price)
        awk -v price="$1" '$3 <= price { print $1 }' fruits.txt
    else
        # If the argument is a fruit name
        fruit_name=$(echo "$1" | tr '[:upper:]' '[:lower:]')
        awk -v fruit="$fruit_name" 'tolower($1) == fruit { print "Vitamin:", $2, "Unit Price:", $3 }' fruits.txt
    fi
else
    # If more than one argument is provided, display an error message
    echo "Error: Too many arguments."
fi
echo "2023EB03181"