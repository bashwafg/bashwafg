windows-shell-setup-add-firstlogoncommands-addtask() {
    # Ensure both arguments are provided
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Usage: windows-shell-setup-add-firstlogoncommands-addtask <command> <description>"
        return 1
    fi

    # Initialize upper bound index if not already set (defaults to 0)
    firstcommandarr_ubound=${firstcommandarr_ubound:-0}

    # Store the current index in a local variable
    local index=$firstcommandarr_ubound

    # Construct the scheduled task command
    local taskCommand="cmd /c schtasks /create /tn \"$2\" /tr \"cmd /c '$1'\" /sc ONLOGON /ru \"SYSTEM\""

    # Store the command and details in the pseudo-array
    eval "firstcommandarr_${index}_commandline='$taskCommand'"  # Store full command
    eval "firstcommandarr_${index}_description='${2:-command $index}'"  # Store description
    eval "firstcommandarr_${index}_requiresinput='false'"  # Scheduled tasks don’t require input

    # Increment the index for the next command
    firstcommandarr_ubound=$((index + 1))
}