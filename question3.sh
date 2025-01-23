#!/bin/bash

DATA_FILE="data.txt"

# Display the menu options
display_menu() {
    echo "1. Add a student record"
    echo "2. Print the list of students above passing marks (>=33 in each subject)"
    echo "3. Print the list of students with their divisions"
    echo "4. Delete a student record"
    echo "5. Exit"
    echo -n "Enter Option: "
}

# Function to validate input
validate_input() {
    local value="$1"
    local min="$2"
    local max="$3"
    local message="$4"
    if [[ ! $value =~ ^[0-9]+$ || $value -lt $min || $value -gt $max ]]; then
        echo "$message"
        return 1
    fi
    return 0
}

# Add a student record
add_student() {
    while true; do
        echo -n "Roll Number (4 digits): "
        read roll
        if ! validate_input "$roll" 1000 9999 "Invalid Roll Number. Must be 4 digits. Try again."; then
            continue
        fi

        echo -n "Name: "
        read name
        if [[ ! $name =~ ^[a-zA-Z\ ]+$ ]]; then
            echo "Invalid Name. Only letters and spaces allowed. Try again."
            continue
        fi

        echo -n "History (0-100): "
        read history
        if ! validate_input "$history" 0 100 "Invalid History marks. Must be between 0 and 100. Try again."; then
            continue
        fi

        echo -n "Geography (0-100): "
        read geography
        if ! validate_input "$geography" 0 100 "Invalid Geography marks. Must be between 0 and 100. Try again."; then
            continue
        fi

        echo -n "Civics (0-100): "
        read civics
        if ! validate_input "$civics" 0 100 "Invalid Civics marks. Must be between 0 and 100. Try again."; then
            continue
        fi

        echo "$roll $name $history $geography $civics" >> "$DATA_FILE"
        echo "Student record added successfully!"
        break
    done
}

# Print students who passed all subjects
print_passing_students() {
    echo "Students who passed all subjects:"
    awk '{
        if ($3 >= 33 && $4 >= 33 && $5 >= 33)
            printf "%-6s  %-20s  History: %-3s  Geography: %-3s  Civics: %-3s\n", $1, $2, $3, $4, $5
    }' "$DATA_FILE"
}

# Calculate and print student divisions
print_divisions() {
    echo "Students with their divisions:"
    awk '{
        total = $3 + $4 + $5;
        avg = total / 3;
        if ($3 >= 33 && $4 >= 33 && $5 >= 33) {
            if (avg >= 75) division = "I";
            else if (avg >= 60) division = "II";
            else if (avg >= 33) division = "III";
        } else {
            division = "Fail";
        }
        printf "%-6s  %-20s  Division: %s\n", $1, $2, division;
    }' "$DATA_FILE"
}

# Delete a student record
delete_student() {
    echo -n "Enter Roll Number to delete: "
    read roll
    if grep -q "^$roll " "$DATA_FILE"; then
        sed -i "/^$roll /d" "$DATA_FILE"
        echo "Student with Roll Number $roll deleted successfully!"
    else
        echo "No student found with Roll Number: $roll"
    fi
}

# Main script logic
main() {
    while true; do
        display_menu
        read option
        case $option in
            1) add_student ;;
            2) print_passing_students ;;
            3) print_divisions ;;
            4) delete_student ;;
            5) echo "Exiting..."; exit 0 ;;
            *) echo "Invalid option. Please try again." ;;
        esac
        echo
    done
}

# Run the script
main
echo "2023EB03181"