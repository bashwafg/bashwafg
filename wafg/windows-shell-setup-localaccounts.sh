windows-shell-setup-localaccounts() {
    local args=()
    local has_users=false

    # Start XML block
    echo -e "\t\t\t<LocalAccounts>"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        if [[ "$1" == "adduser" ]]; then
            # Process the previous user if arguments exist
            if [[ ${#args[@]} -gt 0 ]]; then
                windows-shell-setup-localaccount "${args[@]}"
                args=()
                has_users=true
            fi
        else
            # Collect arguments for the current user
            args+=("$1")
        fi
        shift
    done

    # Process the last collected user if any
    if [[ ${#args[@]} -gt 0 ]]; then
        windows-shell-setup-localaccount "${args[@]}"
        has_users=true
    fi

    # End XML block
    echo -e "\t\t\t</LocalAccounts>"
}