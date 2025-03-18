windows-shell-setup-asynchronouscommand() {
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        local index="$1" command desc order
        eval "command=\${logoncommandarr_${index}_commandline}"
        eval "desc=\${logoncommandarr_${index}_description}"
        eval "order=\${logoncommandarr_${index}_order}"

        [[ -z "$command" ]] && return

        # If order is not set, use WINDOWS_SHELL_SETUP_ORDER and increment it
        if [[ -z "$order" ]]; then
            order="$WINDOWS_SHELL_SETUP_ORDER"
            ((WINDOWS_SHELL_SETUP_ORDER++))
        elif (( order > WINDOWS_SHELL_SETUP_ORDER )); then
            WINDOWS_SHELL_SETUP_ORDER=$((order + 1))
        fi

        echo -e "\t\t\t<AsynchronousCommand wcm:action=\"add\">"
        [[ -n "$desc" ]] && echo -e "\t\t\t\t<Description>$desc</Description>"
        echo -e "\t\t\t\t<Order>$order</Order>"
        printf "\t\t\t\t<CommandLine>%s</CommandLine>\n" "$command"
        echo -e "\t\t\t</AsynchronousCommand>"

        return
    fi

    [[ -z "${WINDOWS_SHELL_SETUP_ORDER}" ]] && WINDOWS_SHELL_SETUP_ORDER=1
    local order="" command="" desc=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            Order) shift; order="$1" ;;
            CommandLine) shift; command="$1" ;;
            Description) shift; desc="$1" ;;
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

    echo -e "\t\t\t<AsynchronousCommand wcm:action=\"add\">"
    [[ -n "$desc" ]] && echo -e "\t\t\t\t<Description>$desc</Description>"
    echo -e "\t\t\t\t<Order>$order</Order>"
    printf "\t\t\t\t<CommandLine>%s</CommandLine>\n" "$command"
    echo -e "\t\t\t</AsynchronousCommand>"
}