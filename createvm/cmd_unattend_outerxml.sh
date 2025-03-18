cmd_unattend_outerxml() {
    local phase=""
    local component=""
    local type="sync"  # Default to synchronous
    local pseudoarray=""
    local args=()
    local has_commands=false

    # Process arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            windowspe|generalize|specialize|offlineservicing|oobesystem|auditsystem|audituser)
                phase="$1" ;;
            setup|shell|deploy)
                component="$1" ;;
            sync|async)
                type="$1" ;;
            addcommand)
                [[ ${#args[@]} -gt 0 ]] && cmd_unattend_innerxml "${args[@]}"  # Process previous command
                args=()
                ;;
            *)
                if [[ -z "$pseudoarray" && -n "$(eval echo "\${cmd_${1}_ubound+set}")" ]]; then
                    pseudoarray="$1"
                else
                    args+=("$1")
                fi
                ;;
        esac
        shift
    done

    # Process any remaining inline commands
    [[ ${#args[@]} -gt 0 ]] && cmd_unattend_innerxml "${args[@]}"

    # If a pseudoarray was specified, check if it exists
    if [[ -n "$pseudoarray" && -n "$(eval echo "\${cmd_${pseudoarray}_ubound+set}")" ]]; then
        has_commands=true
    fi

    # No commands to process, exit early
    if [[ "$has_commands" == false && ${#args[@]} -eq 0 ]]; then
        return
    fi

    # Determine the correct XML tags
    local outer_tag=""
    local inner_tag=""
    local needs_wcm_add=false

    case "$component" in
        setup|deploy)
            outer_tag="Run${type^}"  # Converts sync → RunSync, async → RunAsync
            inner_tag="Run${type^}Command"
            [[ "$component" == "deploy" ]] && needs_wcm_add=true  # Only "deploy" uses wcm:action="add"
            ;;
        shell)
            if [[ "$type" == "sync" ]]; then
                outer_tag="FirstLogonCommands"
                inner_tag="SynchronousCommand"
            else
                outer_tag="LogonCommands"
                inner_tag="AsynchronousCommand"
            fi
            needs_wcm_add=true  # "shell" always uses wcm:action="add"
            ;;
    esac

    # Begin outer XML tag
    echo -e "\t<$outer_tag>"

    # Process all stored pseudoarray commands
    if [[ -n "$pseudoarray" ]]; then
        local index_var="cmd_${pseudoarray}_ubound"
        local count="${!index_var:-0}"
        
        for ((i = 0; i < count; i++)); do
            eval "cmd_unattend_innerxml \"$inner_tag\" \"\$pseudoarray\" \"$i\" \"$needs_wcm_add\""
        done
    fi

    # End outer XML tag
    echo -e "\t</$outer_tag>"
}