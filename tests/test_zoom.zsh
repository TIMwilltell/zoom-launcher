#!/bin/zsh

export env=test

# Source the zoom.zsh script
source ../functions/zoom.zsh

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
BOLD="\e[1m"
RESET="\e[0m"

# Setup - Create a temporary meetings file
echo "Setting up test environment..."

# Initialize or reset the meetings file
echo "meetings=()" > ./.zoom_meetings_tests

normalize() {
    echo "$1" | tr -d '\r' | sed 's/\x1B\[[0-9;]*[a-zA-Z]//g' | sed 's/[[:space:]]*\n//'
}

# Function to run a test case
run_test() {
    description=$1
    command=$2
    expected=$(normalize "$3")

    echo -n "$description... "
    result=$(normalize "$(eval "$command" )")

    if [[ "$result" == "$expected" ]]; then
        echo "${GREEN}PASSED${RESET}"
    else
        echo "${RED}FAILED${RESET}"
        echo "  Expected: $expected"
        echo "  Got:      $result"
        echo "Differences:"
        diff -u <(echo "$expected") <(echo "$result")
    fi
}

# Test cases with an extra newline at the end of each expected output
run_test "Add a meeting" "zoom -a standup:1234567890" "Added meeting standup with ID 1234567890\n"
run_test "List meetings" "zoom -l" "Your meetings:\n => standup \n"
run_test "Remove a meeting" "echo 'Y' | zoom -r standup" "\nRemoved meeting: standup\n"
run_test "List meetings after removal" "zoom -l" "No meetings saved. Use zoom -a name:id to add a meeting.\n"
run_test "Attempt to remove non-existent meeting" "zoom -r 'nonexistent'" "Error: Meeting nonexistent does not exist.\n"
run_test "Display help" "zoom -h" "Usage: zoom [-hl] [-a name:id] [-r name] [-s name|id]\n  -h help       Display help info\n  -a name:id    Add a new meeting with name and ID\n  -r name       Remove a meeting by name\n  -l            List all meetings\n  -s name|id    Open a meeting by name or ID\n"
# Cleanup
echo "Cleaning up..."
rm -f ./.zoom_meetings_tests
