create-batch-from-commands() {
    local batchfile="$1"; shift  
    [[ -z "$batchfile" ]] && { echo "Error: No destination file provided." >&2; return 1; }
    [[ "$#" -gt 0 ]] && { windows-shell-setup-clear-firstlogoncommands; windows-shell-setup-clear-logoncommands; windows-settings-commands "$@"; }
    [[ ! -f "$batchfile" ]] && printf "@echo off\r\n" >> "$batchfile"
    [[ -n "${firstcommandarr_ubound}" ]] && for ((i = 0; i < firstcommandarr_ubound; i++)); do eval "printf \"%s\\r\\n\" \"\$firstcommandarr_${i}_commandline\" >> \"$batchfile\""; done
    [[ -n "${logoncommandarr_ubound}" ]] && for ((i = 0; i < logoncommandarr_ubound; i++)); do eval "printf \"%s\\r\\n\" \"\$logoncommandarr_${i}_commandline\" >> \"$batchfile\""; done
    windows-shell-setup-clear-firstlogoncommands; windows-shell-setup-clear-logoncommands
    echo "Batch file updated at: $batchfile"
}