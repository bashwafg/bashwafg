windows-shell-setup-specialcommands() {
    WINDOWS_SHELL_SETUP_ORDER=1
    local args=()
    local has_commands=false
    local index=0

    # Process inline arguments (if provided)
    while [[ $# -gt 0 ]]; do
        if [[ "$1" == "addcommand" && ${#args[@]} -gt 0 ]]; then
            # Open FirstLogonCommands tag if it's the first command
            [[ "$has_commands" == false ]] && echo -e "\t\t<FirstLogonCommands>" && has_commands=true

            # Process command
            windows-shell-setup-specialcommand "${args[@]}"
            args=()
        else
            args+=("$1")
        fi
        shift
    done

    # If any remaining arguments exist, process them as a command
    if [[ ${#args[@]} -gt 0 ]]; then
        [[ "$has_commands" == false ]] && echo -e "\t\t<FirstLogonCommands>" && has_commands=true
        windows-shell-setup-specialcommand "${args[@]}"
    fi

    # Process commands stored in the specialcommandarr pseudo-array
    if [[ -n "${specialcommandarr_ubound}" && "${specialcommandarr_0_commandline+set}" ]]; then
        [[ "$has_commands" == false ]] && echo -e "\t\t<FirstLogonCommands>" && has_commands=true

        for ((index = 0; index < specialcommandarr_ubound; index++)); do
            eval "windows-shell-setup-specialcommand \"\$index\""
        done
    fi

    # Close FirstLogonCommands tag if commands were added
    [[ "$has_commands" == true ]] && echo -e "\t\t</FirstLogonCommands>"
}