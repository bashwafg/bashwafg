windows-setup-addrunasynchronous() {
    # Initialize an empty array to store command arguments
    local args=()

    # Print the opening <RunAsynchronous> tag
    printf '\t\t\t<RunAsynchronous>\n'

    # Process input arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            addcommand)
                # If there are stored arguments, call windows-setup-runasynchronous with them
                [[ ${#args[@]} -gt 0 ]] && windows-setup-runasynchronous "${args[@]}"
                # Reset the args array
                args=()
                shift
                ;;
            *)
                # Collect arguments for the next command
                args+=("$1")
                shift
                ;;
        esac
    done

    # If there are remaining arguments, process them
    [[ ${#args[@]} -gt 0 ]] && windows-setup-runasynchronous "${args[@]}"

    # Print the closing </RunAsynchronous> tag
    printf '\t\t\t</RunAsynchronous>\n'
}
