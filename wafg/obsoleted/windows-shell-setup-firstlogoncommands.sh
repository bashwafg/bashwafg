windows-shell-setup-firstlogoncommands() {
    WINDOWS_SHELL_SETUP_ORDER=1
    local args=()
    local has_commands=false
    local index=0

    # Process arguments
    while [[ $# -gt 0 ]]; do
        if [[ "$1" == "addcommand" && ${#args[@]} -gt 0 ]]; then
            if [[ "$has_commands" == false ]]; then
                echo -e "\t\t<FirstLogonCommands>"
                has_commands=true
            fi
            windows-shell-setup-synchronouscommand "${args[@]}"
            args=()
        else
            args+=("$1")
        fi
        shift
    done

    # If there are remaining arguments, process them as a command
    if [[ ${#args[@]} -gt 0 ]]; then
        if [[ "$has_commands" == false ]]; then
            echo -e "\t\t<FirstLogonCommands>"
            has_commands=true
        fi
        windows-shell-setup-synchronouscommand "${args[@]}"
    fi

    # Process predefined first commands if set
    if [[ -n "${firstcommandarr_ubound}" && "${firstcommandarr_0_commandline+set}" ]]; then
        if [[ "$has_commands" == false ]]; then
            echo -e "\t\t<FirstLogonCommands>"
            has_commands=true
        fi
        for ((index = 0; index < firstcommandarr_ubound; index++)); do
            eval "windows-shell-setup-synchronouscommand \"\$index\""
        done
    fi

    # Close the XML tag if commands were added
    [[ "$has_commands" == true ]] && echo -e "\t\t</FirstLogonCommands>"
}