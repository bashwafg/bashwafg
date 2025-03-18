windows-shell-setup-add-specialcommands() {
    specialcommandarr_ubound=${specialcommandarr_ubound:-0}
    local index=$specialcommandarr_ubound
    eval "specialcommandarr_${index}_commandline='$1'"
    eval "specialcommandarr_${index}_description='${2:-command $index}'"
    eval "specialcommandarr_${index}_requiresinput='${3:-false}'"
    [[ -n "$4" ]] && eval "specialcommandarr_${index}_order='$4'"
    specialcommandarr_ubound=$((index + 1))
}