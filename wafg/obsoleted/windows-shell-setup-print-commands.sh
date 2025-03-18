windows-shell-setup-print-commands() {
    echo "=== FIRSTCOMMANDARR ==="
    [[ -z "${firstcommandarr_ubound}" ]] && echo "No commands found." ||
    for ((i=0; i<firstcommandarr_ubound; i++)); do
        eval "echo \"[$i] Order: \${firstcommandarr_${i}_order}, Desc: \${firstcommandarr_${i}_description}, Cmd: \${firstcommandarr_${i}_commandline}, Input: \${firstcommandarr_${i}_requiresinput}\""
    done

    echo "=== LOGONCOMMANDARR ==="
    [[ -z "${logoncommandarr_ubound}" ]] && echo "No commands found." ||
    for ((i=0; i<logoncommandarr_ubound; i++)); do
        eval "echo \"[$i] Order: \${logoncommandarr_${i}_order}, Desc: \${logoncommandarr_${i}_description}, Cmd: \${logoncommandarr_${i}_commandline}, Input: \${logoncommandarr_${i}_requiresinput}\""
    done

    echo "=== SPECIALCOMMANDARR ==="
    [[ -z "${specialcommandarr_ubound}" ]] && echo "No commands found." ||
    for ((i=0; i<specialcommandarr_ubound; i++)); do
        eval "echo \"[$i] Order: \${specialcommandarr_${i}_order}, Desc: \${specialcommandarr_${i}_description}, Cmd: \${specialcommandarr_${i}_commandline}, Input: \${specialcommandarr_${i}_requiresinput}\""
    done
}