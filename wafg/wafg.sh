wafg() {
    local args=("$@") i=0 
    local keywords=("header" "start_unattend" "end_unattend" "start_windowsPE" "start_offlineServicing" "start_generalize" "start_specialize" "start_oobeSystem" "end_windowsPE" "end_offlineServicing" "end_generalize" "end_specialize" "end_oobeSystem" "windows-setup" "windows-lua-settings" "windows-international-core" "windows-security-spp" "windows-security-spp-ux" "windows-sqmapi" "windows-shell-setup" "windows-setup-disk-configuration" "windows-setup-disk-configuration-modifypartitions" "windows-setup-disk-configuration-modifypartition" "windows-setup-disk-configuration-createpartitions" "windows-setup-disk-configuration-createpartition" "windows-setup-remainder" "windows-setup-userdata" "windows-setup-addrunasynchronous" "windows-setup-runasynchronous" "windows-setup-addrunsynchronous" "windows-setup-runsynchronous" "windows-setup-imageinstall" "windows-setup-imageinstall-dataimage" "windows-setup-imageinstall-osimage" "windows-international-core-pe" "windows-shell-setup-autologon" "windows-shell-setup-oobe" "windows-shell-setup-localaccount" "windows-shell-setup-localaccounts" "windows-shell-setup-domainaccount" "windows-shell-setup-domainaccountslist" "windows-shell-setup-domainaccounts" "windows-shell-setup-useraccounts" "windows-shell-setup-synchronouscommand" "windows-shell-setup-asynchronouscommand" "windows-shell-setup-firstlogoncommands" "windows-shell-setup-logoncommands" "windows-shell-setup-specialcommands")

    while [ $i -lt ${#args[@]} ]; do
        case "${args[$i]}" in
            header) echo '<?xml version="1.0" encoding="utf-8"?>' ;;
            start_unattend) echo '<unattend xmlns="urn:schemas-microsoft-com:unattend">' ;;
            end_unattend) echo '</unattend>' ;;
            start_windowsPE) echo '    <settings pass="windowsPE">' ;;
            start_offlineServicing) echo '    <settings pass="offlineServicing">' ;;
            start_generalize) echo '    <settings pass="generalize">' ;;
            start_specialize) echo '    <settings pass="specialize">' ;;
            start_oobeSystem) echo '    <settings pass="oobeSystem">' ;;
            end_windowsPE | end_offlineServicing | end_generalize | end_specialize | end_oobeSystem) echo '    </settings>' ;;
            *)  
                for keyword in "${keywords[@]}"; do
                    if [ "${args[$i]}" == "$keyword" ]; then
                        local func_name="${args[$i]}" params=()
                        ((i++))
                        while [ $i -lt ${#args[@]} ] && [[ ! " ${keywords[*]} " =~ " ${args[$i]} " ]]; do params+=("${args[$i]}"); ((i++)); done
                        command -v "$func_name" >/dev/null 2>&1 && "$func_name" "${params[@]}" || echo "Error: Function '$func_name' not found." >&2
                        ((i--)); break
                    fi
                done
                ;;
        esac
        ((i++))
    done
}