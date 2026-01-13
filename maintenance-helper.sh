#!/bin/bash
# maintenance-helper.sh
# Helper functions for maintaining VS Code User configuration
# Source this file: source snippets/maintenance-helper.sh

# Get the User directory path (parent of snippets/)
USER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Sort a JSON file alphabetically by keys
# Usage: sort_json_file <file_path>
sort_json_file() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        echo "Error: File not found: $file" >&2
        return 1
    fi

    # Create backup
    cp "$file" "${file}.backup"

    # Sort using jq (if available) or Python
    if command -v jq &> /dev/null; then
        jq --sort-keys --indent 4 '.' "$file" > "${file}.sorted" && mv "${file}.sorted" "$file"
    elif command -v python3 &> /dev/null; then
        python3 -c "
import json, sys
with open('$file', 'r') as f:
    data = json.load(f)
with open('$file', 'w') as f:
    json.dump(data, f, indent=4, sort_keys=True)
    f.write('\n')
"
    else
        echo "Error: Neither jq nor python3 found. Cannot sort JSON." >&2
        return 1
    fi

    echo "Sorted: $file"
}

# Sort all tracked JSON files in User directory
# Usage: sort_all_json
sort_all_json() {
    local files=("settings.json" "keybindings.json" "tasks.json" "settings-bootstrapper.json")

    for file in "${files[@]}"; do
        local filepath="$USER_DIR/$file"
        if [[ -f "$filepath" ]]; then
            echo "Sorting $file..."
            sort_json_file "$filepath"
        else
            echo "Skipping $file (not found)"
        fi
    done
}

# Compare a JSON file across git branches
# Usage: compare_branches <file_name> <branch1> <branch2>
compare_branches() {
    local file="$1"
    local branch1="$2"
    local branch2="$3"

    if [[ -z "$file" || -z "$branch1" || -z "$branch2" ]]; then
        echo "Usage: compare_branches <file_name> <branch1> <branch2>" >&2
        return 1
    fi

    cd "$USER_DIR" || return 1
    git diff "$branch1".."$branch2" -- "$file"
}

# List environment-specific settings that may need attention
# Usage: find_env_specific_settings
find_env_specific_settings() {
    cd "$USER_DIR" || return 1

    echo "Searching for potentially environment-specific settings..."
    echo ""

    # Common patterns that indicate environment-specific config
    local patterns=(
        "proxy"
        "bloomberg"
        "corp"
        "C:\\\\Users"
        "\/home\/"
        "127.0.0.1"
        "localhost"
        "certificate"
        "token"
    )

    for pattern in "${patterns[@]}"; do
        echo "=== Pattern: $pattern ==="
        grep -n "$pattern" settings.json 2>/dev/null || echo "  (none found)"
        echo ""
    done
}

# Validate JSON syntax for all tracked files
# Usage: validate_all_json
validate_all_json() {
    local files=("settings.json" "keybindings.json" "tasks.json" "settings-bootstrapper.json")
    local errors=0

    for file in "${files[@]}"; do
        local filepath="$USER_DIR/$file"
        if [[ -f "$filepath" ]]; then
            echo -n "Validating $file... "
            if command -v jq &> /dev/null; then
                if jq empty "$filepath" 2>/dev/null; then
                    echo "✓ Valid"
                else
                    echo "✗ Invalid JSON"
                    ((errors++))
                fi
            elif command -v python3 &> /dev/null; then
                if python3 -c "import json; json.load(open('$filepath'))" 2>/dev/null; then
                    echo "✓ Valid"
                else
                    echo "✗ Invalid JSON"
                    ((errors++))
                fi
            else
                echo "? Cannot validate (jq or python3 required)"
            fi
        fi
    done

    if [[ $errors -eq 0 ]]; then
        echo ""
        echo "All JSON files are valid ✓"
        return 0
    else
        echo ""
        echo "Found $errors invalid JSON file(s) ✗"
        return 1
    fi
}

# Show git status with helpful context
# Usage: user_status
user_status() {
    cd "$USER_DIR" || return 1

    echo "=== User Directory Status ==="
    echo "Directory: $USER_DIR"
    echo "Branch: $(git branch --show-current)"
    echo ""
    git status --short
    echo ""
    echo "Tracked JSON files:"
    ls -lh settings.json keybindings.json tasks.json settings-bootstrapper.json 2>/dev/null | tail -n +2
}

# Quick commit and push for User directory
# Usage: user_commit "commit message"
user_commit() {
    local message="$1"

    if [[ -z "$message" ]]; then
        echo "Usage: user_commit \"commit message\"" >&2
        return 1
    fi

    cd "$USER_DIR" || return 1

    # Validate JSON before committing
    if ! validate_all_json; then
        echo ""
        echo "Aborting commit due to JSON validation errors"
        return 1
    fi

    git add settings.json keybindings.json tasks.json settings-bootstrapper.json AGENTS.md README.md Makefile
    git commit -m "$message"
    git push
}

# Display available functions
# Usage: maintenance_help
maintenance_help() {
    cat << 'EOF'
Maintenance Helper Functions:

  sort_json_file <file>          Sort a single JSON file
  sort_all_json                  Sort all tracked JSON files
  compare_branches <file> <b1> <b2>  Compare file across branches
  find_env_specific_settings     Search for environment-specific settings
  validate_all_json              Validate JSON syntax of all files
  user_status                    Show git status with context
  user_commit "message"          Validate, commit, and push changes
  maintenance_help               Show this help message

Environment:
  USER_DIR = $USER_DIR

EOF
}

# Show help on source
echo "Maintenance helper functions loaded."
echo "Run 'maintenance_help' to see available functions."
