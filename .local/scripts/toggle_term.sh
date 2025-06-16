#!/bin/bash

TERMINAL_BIN="footclient"
SCRATCHPAD_MARK="terminal"
CLASS_NAME="footclient"  # Changed from "foot" to "footclient"
SERVER_CHECK_TIMEOUT=3

# Function to ensure foot server is running
ensure_server() {
    if ! pgrep -f "foot --server" > /dev/null; then
        echo "Starting foot server..."
        foot --server &
        
        for i in $(seq 1 $SERVER_CHECK_TIMEOUT); do
            sleep 0.5
            if pgrep -f "foot --server" > /dev/null; then
                sleep 0.5
                break
            fi
        done
    fi
}

# Function to get window information
get_windows_info() {
    swaymsg -t get_tree | jq -r --arg class "$CLASS_NAME" '
       [.. | objects | select(.app_id == $class) | 
       {id: .id, workspace: (.workspace // "unknown"), marks: .marks}]
    '
}

# Main logic
main() {
    ensure_server
    
    WINDOWS_INFO=$(get_windows_info)
    
    # Check if any terminal is in scratchpad (has our mark) FIRST
    SCRATCHPAD_WINDOW=$(echo "$WINDOWS_INFO" | jq -r --arg mark "$SCRATCHPAD_MARK" '
       .[] | select(.marks | contains([$mark])) | .id
    ')
    
    if [[ -n "$SCRATCHPAD_WINDOW" && "$SCRATCHPAD_WINDOW" != "null" ]]; then
        # Bring back from scratchpad
        swaymsg "[con_id=$SCRATCHPAD_WINDOW] move to workspace current, floating disable, unmark $SCRATCHPAD_MARK, focus"
        exit 0
    fi
    
    # Look for visible windows (not in scratchpad)
    VISIBLE_WINDOW=$(echo "$WINDOWS_INFO" | jq -r --arg mark "$SCRATCHPAD_MARK" '
        .[] | select(.marks | contains([$mark]) | not) | .id
    ' | head -n1)
    
    if [[ -n "$VISIBLE_WINDOW" && "$VISIBLE_WINDOW" != "null" ]]; then
        # Hide the visible window
        swaymsg "[con_id=$VISIBLE_WINDOW] mark $SCRATCHPAD_MARK, move scratchpad"
        exit 0
    fi
    
    # Only if no windows exist at all, launch one
    if [[ "$WINDOWS_INFO" == "[]" || -z "$WINDOWS_INFO" ]]; then
       $TERMINAL_BIN &
       
       # Wait for window to appear
       for i in {1..20}; do
           sleep 0.1
           WINDOWS_INFO=$(get_windows_info)
           [[ "$WINDOWS_INFO" != "[]" && -n "$WINDOWS_INFO" ]] && break
       done
    fi
}

main "$@"
