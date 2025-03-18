windows-setup-runsynccommand() {
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        # Handling single numeric argument (retrieving stored command by index)
        local index="$1"
        local path desc domain user password order

        eval "path=\${runsynccommandarr_${index}_path}"
        eval "desc=\${runsynccommandarr_${index}_description}"
        eval "domain=\${runsynccommandarr_${index}_domain}"
        eval "user=\${runsynccommandarr_${index}_user}"
        eval "password=\${runsynccommandarr_${index}_password}"
        eval "order=\${runsynccommandarr_${index}_order}"

        [[ -z "$path" ]] && return

        # Determine the order value
        if [[ -z "$order" ]]; then
            order="$WINDOWS_SHELL_SETUP_ORDER"
            ((WINDOWS_SHELL_SETUP_ORDER++))
        elif (( order > WINDOWS_SHELL_SETUP_ORDER )); then
            WINDOWS_SHELL_SETUP_ORDER=$((order + 1))
        fi

        # Print the XML output
        echo -e "\t<RunSynchronousCommand>"
        echo -e "\t\t<Order>$order</Order>"
        echo -e "\t\t<Path>$path</Path>"
        [[ -n "$desc" ]] && echo -e "\t\t<Description>$desc</Description>"

        # Print credentials only if at least one field is set
        if [[ -n "$domain" || -n "$user" || -n "$password" ]]; then
            echo -e "\t\t<Credentials>"
            [[ -n "$domain" ]] && echo -e "\t\t\t<Domain>$domain</Domain>"
            [[ -n "$user" ]] && echo -e "\t\t\t<UserName>$user</UserName>"
            [[ -n "$password" ]] && echo -e "\t\t\t<Password>$password</Password>"
            echo -e "\t\t</Credentials>"
        fi

        echo -e "\t</RunSynchronousCommand>"
        return
    fi

    # Handling keyword-based parameters
    [[ -z "${WINDOWS_SHELL_SETUP_ORDER}" ]] && WINDOWS_SHELL_SETUP_ORDER=1
    local order="" path="" desc="" domain="" user="" password=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            Path) shift; path="$1" ;;
            Description) shift; desc="$1" ;;
            Domain) shift; domain="$1" ;;
            UserName) shift; user="$1" ;;
            Password) shift; password="$1" ;;
            Order) shift; order="$1" ;;
        esac
        shift
    done

    [[ -z "$path" ]] && return

    # Determine the order value
    if [[ -z "$order" ]]; then
        order="$WINDOWS_SHELL_SETUP_ORDER"
        ((WINDOWS_SHELL_SETUP_ORDER++))
    elif (( order > WINDOWS_SHELL_SETUP_ORDER )); then
        WINDOWS_SHELL_SETUP_ORDER=$((order + 1))
    fi

    # Print the XML output
    echo -e "\t<RunSynchronousCommand>"
    echo -e "\t\t<Order>$order</Order>"
    echo -e "\t\t<Path>$path</Path>"
    [[ -n "$desc" ]] && echo -e "\t\t<Description>$desc</Description>"

    # Print credentials only if at least one field is set
    if [[ -n "$domain" || -n "$user" || -n "$password" ]]; then
        echo -e "\t\t<Credentials>"
        [[ -n "$domain" ]] && echo -e "\t\t\t<Domain>$domain</Domain>"
        [[ -n "$user" ]] && echo -e "\t\t\t<UserName>$user</UserName>"
        [[ -n "$password" ]] && echo -e "\t\t\t<Password>$password</Password>"
        echo -e "\t\t</Credentials>"
    fi

    echo -e "\t</RunSynchronousCommand>"
}