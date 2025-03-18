windows-shell-setup-clear-specialcommands() {
    unset specialcommandarr_ubound
    local i=0
    while [[ -n "$(eval echo "\${specialcommandarr_${i}_commandline+set}")" ]]; do
        unset specialcommandarr_${i}_commandline
        unset specialcommandarr_${i}_description
        unset specialcommandarr_${i}_requiresinput
        unset specialcommandarr_${i}_order
        ((i++))
    done
}