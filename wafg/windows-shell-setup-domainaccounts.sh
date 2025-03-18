windows-shell-setup-domainaccounts() {
    local lists=()      # Array to store lists of domain accounts
    local current_args=()  # Temporary array for the current list

    # Process input arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            addlist)
                # Save the current list if it contains elements
                [[ ${#current_args[@]} -gt 0 ]] && lists+=("${current_args[*]}")
                current_args=()  # Reset for the next list
                ;;
            *)
                # Collect arguments into the current list
                current_args+=("$1")
                ;;
        esac
        shift
    done

    # Add the last collected list if it has elements
    [[ ${#current_args[@]} -gt 0 ]] && lists+=("${current_args[*]}")

    # If there are no lists, return early
    [[ ${#lists[@]} -eq 0 ]] && return

    # Generate XML output
    echo -e "\t\t\t<DomainAccounts>"
    for list in "${lists[@]}"; do
        windows-shell-setup-domainaccountslist $list
    done
    echo -e "\t\t\t</DomainAccounts>"
}