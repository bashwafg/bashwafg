windows-shell-setup-add-logoncommands() {
    # Initialize logon command array upper bound if not already set
    logoncommandarr_ubound=${logoncommandarr_ubound:-0}

    # Assign current index
    local index=$logoncommandarr_ubound

    # Store command line
    eval "logoncommandarr_${index}_commandline='$1'"

    # Store description, defaulting to "command <index>" if not provided
    eval "logoncommandarr_${index}_description='${2:-command $index}'"

    # Store requiresInput flag, defaulting to "false" if not provided
    eval "logoncommandarr_${index}_requiresinput='${3:-false}'"

    # Store order if provided
    [[ -n "$4" ]] && eval "logoncommandarr_${index}_order='$4'"

    # Increment the upper bound index
    logoncommandarr_ubound=$((index + 1))
}