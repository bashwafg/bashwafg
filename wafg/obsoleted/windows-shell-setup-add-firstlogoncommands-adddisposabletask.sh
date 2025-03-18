windows-shell-setup-add-firstlogoncommands-adddisposabletask() {
    # Ensure both arguments are provided
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Usage: windows-shell-setup-add-firstlogoncommands-adddisposabletask <command> <description>"
        return 1
    fi

    # Initialize upper bound index if not already set (defaults to 0)
    firstcommandarr_ubound=${firstcommandarr_ubound:-0}

    # Store the current index in a local variable
    local index=$firstcommandarr_ubound

    # Construct the self-deleting scheduled task command
    local taskCommand="cmd /c schtasks /create /tn \"$2\" /tr \"cmd /c '$1 & timeout /t 3 & schtasks /delete /tn \"$2\" /f'\" /sc once /st 00:00 /f /rl highest /ru SYSTEM"

    # Store the command and details in the pseudo-array
    eval "firstcommandarr_${index}_commandline='$taskCommand'"  # Store full command
    eval "firstcommandarr_${index}_description='${2:-command $index}'"  # Store description
    eval "firstcommandarr_${index}_requiresinput='false'"  # Scheduled tasks don’t require input

    # Increment the index for the next command
    firstcommandarr_ubound=$((index + 1))
}