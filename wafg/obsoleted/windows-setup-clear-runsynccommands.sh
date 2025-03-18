windows-setup-clear-runsynccommands() {
    unset runsynccommandarr_ubound
    local i=0
    while [[ -n "$(eval echo "\${runsynccommandarr_${i}_path+set}")" ]]; do
        unset runsynccommandarr_${i}_path
        unset runsynccommandarr_${i}_description
        unset runsynccommandarr_${i}_order
        unset runsynccommandarr_${i}_domain
        unset runsynccommandarr_${i}_user
        unset runsynccommandarr_${i}_password
        ((i++))
    done
}