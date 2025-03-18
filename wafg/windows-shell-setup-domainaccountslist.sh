windows-shell-setup-domainaccountslist() {
    # Initialize variables
    local domain=""
    local accounts=()

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            Domain) shift; domain="$1" ;;  # Store domain name
            adduser) 
                [[ ${#accounts[@]} -gt 0 ]] && accounts+=("adduser")  # Add "adduser" separator if needed
                accounts+=("$1") ;;  # Add user command
            *) accounts+=("$1") ;;  # Store all other arguments
        esac
        shift
    done

    # If no domain is specified, exit
    [[ -z "$domain" ]] && return

    # Start XML output
    echo -e "\t\t\t\t<DomainAccountList wcm:action=\"add\">"

    # Process accounts and call windows-shell-setup-domainaccount
    local current_args=()
    for arg in "${accounts[@]}" "adduser"; do
        if [[ "$arg" == "adduser" ]]; then
            [[ ${#current_args[@]} -gt 0 ]] && windows-shell-setup-domainaccount "${current_args[@]}"
            current_args=()
        else
            current_args+=("$arg")
        fi
    done

    # End XML output
    echo -e "\t\t\t\t\t<Domain>$domain</Domain>"
    echo -e "\t\t\t\t</DomainAccountList>"
}