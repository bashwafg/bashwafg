windows-shell-setup-oobe() {
    # Default values for OOBE settings
    local hide_eula="true" hide_local_screen="" hide_oem_screen="true"
    local hide_online_screens="true" hide_wireless="true" network_location="Home"
    local oem_app_id="" protect_pc="1" skip_admin_profile="" skip_notify_lang=""
    local skip_winre_init="" skip_user_oobe="true" skip_machine_oobe="true"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            HideEULAPage) shift; hide_eula="$1" ;;
            HideLocalAccountScreen) shift; hide_local_screen="$1" ;;
            HideOEMRegistrationScreen) shift; hide_oem_screen="$1" ;;
            HideOnlineAccountScreens) shift; hide_online_screens="$1" ;;
            HideWirelessSetupInOOBE) shift; hide_wireless="$1" ;;
            NetworkLocation) shift; network_location="$1" ;;
            OEMAppID) shift; oem_app_id="$1" ;;
            ProtectYourPC) shift; protect_pc="$1" ;;
            SkipAdministratorProfileRemoval) shift; skip_admin_profile="$1" ;;
            SkipNotifyUILanguageChange) shift; skip_notify_lang="$1" ;;
            SkipWinREInitialization) shift; skip_winre_init="$1" ;;
            SkipUserOOBE) shift; skip_user_oobe="$1" ;;
            SkipMachineOOBE) shift; skip_machine_oobe="$1" ;;
        esac
        shift
    done

    # Generate XML output using multiple echo commands
    echo -e "\t\t<OOBE>"
    echo -e "\t\t\t<HideEULAPage>$hide_eula</HideEULAPage>"
    [[ -n "$hide_local_screen" ]] && echo -e "\t\t\t<HideLocalAccountScreen>$hide_local_screen</HideLocalAccountScreen>"
    echo -e "\t\t\t<HideOEMRegistrationScreen>$hide_oem_screen</HideOEMRegistrationScreen>"
    echo -e "\t\t\t<HideOnlineAccountScreens>$hide_online_screens</HideOnlineAccountScreens>"
    echo -e "\t\t\t<HideWirelessSetupInOOBE>$hide_wireless</HideWirelessSetupInOOBE>"
    echo -e "\t\t\t<NetworkLocation>$network_location</NetworkLocation>"
    [[ -n "$oem_app_id" ]] && echo -e "\t\t\t<OEMAppID>$oem_app_id</OEMAppID>"
    echo -e "\t\t\t<SkipUserOOBE>$skip_user_oobe</SkipUserOOBE>"
    echo -e "\t\t\t<SkipMachineOOBE>$skip_machine_oobe</SkipMachineOOBE>"
    echo -e "\t\t\t<ProtectYourPC>$protect_pc</ProtectYourPC>"

    # Handle VMModeOptimizations section if needed
    if [[ -n "$skip_admin_profile" || -n "$skip_notify_lang" || -n "$skip_winre_init" ]]; then
        echo -e "\t\t\t<VMModeOptimizations>"
        [[ -n "$skip_admin_profile" ]] && echo -e "\t\t\t\t<SkipAdministratorProfileRemoval>$skip_admin_profile</SkipAdministratorProfileRemoval>"
        [[ -n "$skip_notify_lang" ]] && echo -e "\t\t\t\t<SkipNotifyUILanguageChange>$skip_notify_lang</SkipNotifyUILanguageChange>"
        [[ -n "$skip_winre_init" ]] && echo -e "\t\t\t\t<SkipWinREInitialization>$skip_winre_init</SkipWinREInitialization>"
        echo -e "\t\t\t</VMModeOptimizations>"
    fi

    echo -e "\t\t</OOBE>"
}
