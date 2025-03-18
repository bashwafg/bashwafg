windows-setup-add-runsynccommands() {
    runsynccommandarr_ubound=${runsynccommandarr_ubound:-0}
    local index=$runsynccommandarr_ubound

    eval "runsynccommandarr_${index}_path='$1'"
    eval "runsynccommandarr_${index}_description='${2:-command $index}'"
    eval "runsynccommandarr_${index}_order='${3:-}'"
    eval "runsynccommandarr_${index}_domain='${4:-}'"
    eval "runsynccommandarr_${index}_user='${5:-}'"
    eval "runsynccommandarr_${index}_password='${6:-}'"

    runsynccommandarr_ubound=$((index + 1))
}