windows-shell-setup-synchronouscommand() {
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        local index="$1" command desc req order
        eval "command=\${firstcommandarr_${index}_commandline}"
        eval "desc=\${firstcommandarr_${index}_description}"
        eval "req=\${firstcommandarr_${index}_requiresinput}"
        eval "order=\${firstcommandarr_${index}_order}"

        [[ -z "$command" ]] && return

        # If order is not set, use WINDOWS_SHELL_SETUP_ORDER and increment it
        if [[ -z "$order" ]]; then
            order="$WINDOWS_SHELL_SETUP_ORDER"
            ((WINDOWS_SHELL_SETUP_ORDER++))
        elif (( order > WINDOWS_SHELL_SETUP_ORDER )); then
            WINDOWS_SHELL_SETUP_ORDER=$((order + 1))
        fi

        echo -e "\t\t\t<SynchronousCommand wcm:action=\"add\">"
        echo -e "\t\t\t\t<Order>$order</Order>"
        [[ -n "$desc" ]] && echo -e "\t\t\t\t<Description>$desc</Description>"
        echo -e "\t\t\t\t<RequiresUserInput>$req</RequiresUserInput>"
        printf "\t\t\t\t<CommandLine>%s</CommandLine>" "$command"
        echo -e "\n\t\t\t</SynchronousCommand>"

        return
    fi

    [[ -z "${WINDOWS_SHELL_SETUP_ORDER}" ]] && WINDOWS_SHELL_SETUP_ORDER=1
    local order="" command="" desc="" req="false"

    while [[ $# -gt 0 ]]; do
        case "$1" in
            Order) shift; order="$1" ;;
            CommandLine) shift; command="$1" ;;
            Description) shift; desc="$1" ;;
            RequiresUserInput) shift; req="$1" ;;
        esac
        shift
    done

    [[ -z "$command" ]] && return

    # If order is not set, use WINDOWS_SHELL_SETUP_ORDER and increment it
    if [[ -z "$order" ]]; then
        order="$WINDOWS_SHELL_SETUP_ORDER"
        ((WINDOWS_SHELL_SETUP_ORDER++))
    elif (( order > WINDOWS_SHELL_SETUP_ORDER )); then
        WINDOWS_SHELL_SETUP_ORDER=$((order + 1))
    fi

    echo -e "\t\t\t<SynchronousCommand wcm:action=\"add\">"
    echo -e "\t\t\t\t<Order>$order</Order>"
    [[ -n "$desc" ]] && echo -e "\t\t\t\t<Description>$desc</Description>"
    echo -e "\t\t\t\t<RequiresUserInput>$req</RequiresUserInput>"
    printf "\t\t\t\t<CommandLine>%s</CommandLine>" "$command"
    echo -e "\n\t\t\t</SynchronousCommand>"
}