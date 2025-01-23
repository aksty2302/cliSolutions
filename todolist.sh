#!/bin/bash

TODO_FILE="todo.txt"

# Ensure the todo file exists
touch "$TODO_FILE"

# Function to display tasks with formatting
display_tasks() {
    awk '{
        status = ($3 == 0 ? "Not Started" : ($3 == 1 ? "Doing" : "Complete"));
        printf "%-6s  %-20s  %s\n", $1, $2, status;
    }' "$TODO_FILE"
}

# Function to add a new task
add_task() {
    local task_description="$1"
    local next_serial=$(($(wc -l < "$TODO_FILE") + 1))
    echo "$next_serial $task_description 0" >> "$TODO_FILE"
}

# Function to filter tasks by status
filter_tasks_by_status() {
    local status_code="$1"
    local status_name=""
    case "$status_code" in
        0) status_name="Not Started" ;;
        1) status_name="Doing" ;;
        2) status_name="Complete" ;;
    esac
    grep -E "^[0-9]+ .+ $status_code$" "$TODO_FILE" | display_tasks
}

# Function to mark tasks as complete
mark_tasks_complete() {
    for serial in "$@"; do
        sed -i "/^$serial /s/ [0-2]$/ 2/" "$TODO_FILE"
        echo "Task $serial marked as complete."
    done
}

# Function to delete tasks
delete_tasks() {
    for serial in "$@"; do
        sed -i "/^$serial /d" "$TODO_FILE"
        echo "Task $serial deleted."
    done
    # Reassign serial numbers after deletion
    local temp_file=$(mktemp)
    awk '{print NR, $2, $3}' "$TODO_FILE" > "$temp_file"
    mv "$temp_file" "$TODO_FILE"
}

# Main script logic
case "$1" in
    "")
        # Display tasks that are not complete
        grep -E "^[0-9]+ .+ [01]$" "$TODO_FILE" | display_tasks
        ;;
    "display")
        display_tasks
        ;;
    "add")
        if [ -z "$2" ]; then
            echo "Error: No task description provided."
            exit 1
        fi
        add_task "$2"
        ;;
    "todo")
        filter_tasks_by_status 0
        ;;
    "doing")
        filter_tasks_by_status 1
        ;;
    "complete")
        filter_tasks_by_status 2
        ;;
    "mark_complete")
        shift
        if [ $# -eq 0 ]; then
            echo "Error: No task serial numbers provided."
            exit 1
        fi
        mark_tasks_complete "$@"
        ;;
    "delete")
        shift
        if [ $# -eq 0 ]; then
            echo "Error: No task serial numbers provided."
            exit 1
        fi
        delete_tasks "$@"
        ;;
    *)
        echo "Error: Invalid command."
        exit 1
        ;;
esac
echo "2023eb03181"