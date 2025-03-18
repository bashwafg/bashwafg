windows-shell-setup-add-firstlogoncommands() {
    # Initialize firstcommandarr_ubound if not set
    firstcommandarr_ubound=${firstcommandarr_ubound:-0}

    # Set the current index
    local index=$firstcommandarr_ubound

    # Store command properties using dynamic variable names
    eval "firstcommandarr_${index}_commandline='$1'"
    eval "firstcommandarr_${index}_description='${2:-command $index}'"
    eval "firstcommandarr_${index}_requiresinput='${3:-false}'"

    # Optionally set the order if the fourth argument is provided
    [[ -n "$4" ]] && eval "firstcommandarr_${index}_order='$4'"

    # Increment the upper bound index
    firstcommandarr_ubound=$((index + 1))
}