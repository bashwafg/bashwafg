windows-shell-setup-clear-firstlogoncommands() {
    # Unset the upper bound variable if it exists
    unset firstcommandarr_ubound

    # Initialize index
    local i=0

    # Loop through command entries until an unset variable is encountered
    while [[ -n "$(eval echo "\${firstcommandarr_${i}_commandline+set}")" ]]; do
        unset firstcommandarr_${i}_commandline
        unset firstcommandarr_${i}_description
        unset firstcommandarr_${i}_requiresinput
        unset firstcommandarr_${i}_order
        ((i++))
    done
}