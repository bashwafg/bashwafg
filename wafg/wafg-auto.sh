wafg-auto() {
    # Default values for parameters
    local mode="${mode:-EFI}"
    local computername="${computername:-"*"}"
    local username="${username:-"user"}"
    local password="${password:-"qwerty"}"
    local region="${region:-"en-CA"}"
    local setupregion="${setupregion:-"en-GB"}"
    local setupregionspecified=$([[ -n "$setupregion" ]] && echo "true" || echo "")
    local timezone="${timezone:-"Eastern Standard Time"}"
    local inputlocale="${inputlocale:-"1009:00000409"}"
    local willwipedisk="${willwipedisk:-"false"}"
    local createpartitions="${createpartitions:-""}"
    local modifypartitions="${modifypartitions:-""}"
    local installimage="${installimage:-"Windows 10 Pro"}"
    local productkey="${productkey:-""}"
    local organization="${organization:-""}"
    local registeredowner="${registeredowner:-""}"
    local verbose="${verbose:-false}"
	local dryrun="${dryrun:-false}"

    # Image and WIM settings
    local isofile="${isofile:-""}"
    local wimpath="${wimpath:-""}"
    local wimdomain="${wimdomain:-""}"
    local wimuser="${wimuser:-""}"
    local wimpassword="${wimpassword:-""}"

    # Miscellaneous settings
    local noautopartitions="${noautopartitions:-""}"
    local autoselectpartition="${autoselectpartition:-true}"
    local InstallTo="${InstallTo:-""}"
    local windowssettings="${windowssettings:-""}"

    unset WINDOWS_SHELL_SETUP_ORDER

    # Parse command-line arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
			BIOS|EFI) mode="$1" ;;
            setupregion) shift; setupregion="$1"; setupregionspecified=true ;;
            windowssettings) shift; windowssettings="$1" ;;
            WillWipeDisk) willwipedisk="true" ;;
            DontWipeDisk) willwipedisk="false" ;;
            NoAutoPartitions) noautopartitions="true" ;;
            DefaultKey) productkey="W269N-WFGWX-YVC9B-4J6C9-T83GX" ;;
            InstallTo) shift; IFS=':' read -r disk_id partition_id <<< "$1"; InstallTo="DiskID $disk_id PartitionID $partition_id"; autoselectpartition="false" ;;
            verbose) verbose=true ;;
			dryrun) dryrun=true ;;
			computername|username|password|region|timezone|inputlocale|productkey|organization|installimage|isofile|wimpath|wimdomain|wimuser|wimpassword|autoselectpartition)
                wafg_temp="$1"; shift
                declare "$wafg_temp"="$1"
                ;;
            firstcommand|logoncommand)
                local fc_cmd="" fc_desc="" fc_order="" fc_requires_input="false" cmd_type="$1"; shift;
                while [[ $# -gt 0 ]]; do
                    case "$1" in
                        CommandLine) shift; fc_cmd="$1" ;;
                        Description) shift; fc_desc="$1" ;;
                        Order) shift; fc_order="$1" ;;
                        RequiresUserInput) shift; fc_requires_input="$1" ;;
                        *) break ;;
                    esac
                    shift
                done
                # Ensure CommandLine is provided before adding to the command list
                [[ -n "$fc_cmd" ]] && { [[ "$cmd_type" == "firstcommand" ]] && echo windows-shell-setup-add-firstlogoncommands "$(printf "%q" "$fc_cmd")" "$fc_desc" "$fc_requires_input" "$fc_order" || windows-shell-setup-add-logoncommands "$(printf "%q" "$fc_cmd")" "$fc_desc" "$fc_requires_input" "$fc_order"; } || echo "Error: Missing CommandLine for $cmd_type"
                ;;
            *)
                echo "Warning: Unknown option '$1' will be ignored (wafg-auto)."
                shift
                continue
                ;;
        esac
        shift
    done

    # Determine setup region from ISO if not specified
    if [[ -n "$isofile" && -z "$setupregionspecified" ]]; then
        local MNT="/tmp/iso-mount-$(date +"%Y%m%d-%H%M%S")"
        mkdir -p "$MNT"
        mount -o loop "$isofile" "$MNT" >/dev/null 2>&1
        setupregion=$(grep -oP "^\w{2}-\w{2}" "$MNT/sources/lang.ini" | head -n 1)
        umount "$MNT" >/dev/null 2>&1
        rmdir "$MNT" >/dev/null 2>&1
    fi

    # Set registered owner if not provided
    [[ -z "$registeredowner" ]] && registeredowner="$username"

    # Construct disk configuration
    local diskconfig="disk adddisk WillWipeDisk $willwipedisk"
    [[ -z "$noautopartitions" ]] && diskconfig+=" createpartitions ${createpartitions:-$mode} modifypartitions ${modifypartitions:-$mode}"
    [[ -z "$InstallTo" ]] && diskconfig+=" InstallToAvailablePartition false" || ([[ -n "$autoselectpartition" ]] && diskconfig+=" InstallToAvailablePartition $autoselectpartition")

    # Construct installation metadata
    local installmetadata=""
    if [[ -n "$wimpath$wimdomain$wimuser$wimpassword$installimage" ]]; then
        installmetadata="imageinstall osimage"
        [[ -n "$wimpath" ]] && installmetadata+=" Path \"$wimpath\""
        [[ -n "$wimdomain" ]] && installmetadata+=" Domain \"$wimdomain\""
        [[ -n "$wimuser" ]] && installmetadata+=" Username \"$wimuser\""
        [[ -n "$wimpassword" ]] && installmetadata+=" Password \"$wimpassword\""
        [[ -n "$installimage" ]] && installmetadata+=" MetaData /IMAGE/$([[ "$installimage" =~ ^[0-9]+$ ]] && echo "INDEX" || echo "NAME") \"$installimage\""
    fi

    # Apply Windows settings if specified
    [[ "$dryrun" != true && -n "$windowssettings" ]] && windows-settings-commands $windowssettings
	
	    # Initialize an empty variable for optional logon commands
    local logon_commands_section=()
	local special_commands_section=()

    # Add first logon commands if they exist
    [[ ${firstcommandarr_ubound:-0} -gt 0 ]] && logon_commands_section+=(firstlogoncommands "-" )

    # Add logon commands if they exist
    [[ ${logoncommandarr_ubound:-0} -gt 0 ]] && logon_commands_section+=(logoncommands "-")
	
	[[ ${specialcommandarr_ubound:-0} -gt 0 ]] && special_commands_section+=(specialcommands "-")
	
    # Construct the wafg command
    local wafg_cmd=(wafg header start_unattend start_windowsPE windows-international-core-pe Region "$setupregion" InputLocale "$inputlocale" windows-setup "$diskconfig" "$installmetadata" "$InstallTo" userdata Key "\"$productkey\"" FullName "$username" Organization "\"$organization\"" end_windowsPE start_offlineServicing windows-lua-settings EnableLUA true end_offlineServicing start_generalize windows-security-spp SkipRearm 1 end_generalize start_specialize windows-international-core Region "$region" InputLocale "$inputlocale" windows-security-spp-ux SkipAutoActivation true windows-sqmapi CEIPEnabled 0 windows-shell-setup ComputerName "\"$computername\"" ProductKey "\"$productkey\"" "${special_commands_section[@]}" end_specialize start_oobeSystem windows-shell-setup autologon Username "$username" Password "$password" oobe "-" useraccounts localaccounts adduser Name "$username" Group Administrators Password "$password" RegisteredOwner "$registeredowner" DisableAutoDaylightTimeSet false "${logon_commands_section[@]}" TimeZone "\"$timezone\"" end_oobeSystem end_unattend);
    
    # Execute the wafg command
    [[ "$verbose" == true ]] && echo "Executing wafg command:" && printf "%s " "${wafg_cmd[@]}" && echo ""
    [[ "$dryrun" != true ]] && eval "${wafg_cmd[@]}"
}