windows-shell-setup-clear-logoncommands() {
    # Unset the upper bound variable
    unset logoncommandarr_ubound
    
    # Initialize index
    local i=0

    # Loop through the logon command array and unset each entry
    while [[ -n "$(eval echo "\${logoncommandarr_${i}_commandline+set}")" ]]; do
        unset logoncommandarr_${i}_commandline logoncommandarr_${i}_description logoncommandarr_${i}_order
        ((i++))
    done
}