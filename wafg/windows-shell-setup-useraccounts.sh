windows-shell-setup-useraccounts() {
    # Initialize arrays for local and domain accounts
    local args_local=()
    local args_domain=()
    local section=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            localaccounts) section="local"; shift ;;  
            domainaccounts) section="domain"; shift ;;  
            *)  
                [[ "$section" == "local" ]] && args_local+=("$1")  
                [[ "$section" == "domain" ]] && args_domain+=("$1")  
                shift  
                ;;  
        esac
    done

    # If no accounts were provided, exit the function
    [[ ${#args_local[@]} -eq 0 && ${#args_domain[@]} -eq 0 ]] && return

    # Output the <UserAccounts> section
    echo -e "\t\t<UserAccounts>"

    # Call respective functions if accounts exist
    [[ ${#args_local[@]} -gt 0 ]] && windows-shell-setup-localaccounts "${args_local[@]}"
    [[ ${#args_domain[@]} -gt 0 ]] && windows-shell-setup-domainaccounts "${args_domain[@]}"

    # Close the <UserAccounts> section
    echo -e "\t\t</UserAccounts>"
}