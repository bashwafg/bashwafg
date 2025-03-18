windows-setup-addrunsynchronous() {
    # Array to store command arguments
    local args=()

    # Print the opening RunSynchronous tag
    printf '\t\t\t<RunSynchronous>\n'

    # Process input arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            addcommand)
                # If args array is not empty, call windows-setup-runsynchronous with stored arguments
                [[ ${#args[@]} -gt 0 ]] && windows-setup-runsynchronous "${args[@]}"
                # Reset args array
                args=()
                shift
                ;;
            *)
                # Collect arguments into args array
                args+=("$1")
                shift
                ;;
        esac
    done

    # If there are remaining arguments, call windows-setup-runsynchronous
    [[ ${#args[@]} -gt 0 ]] && windows-setup-runsynchronous "${args[@]}"

    # Print the closing RunSynchronous tag
    printf '\t\t\t</RunSynchronous>\n'
}