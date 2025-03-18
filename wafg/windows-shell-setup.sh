windows-shell-setup() {
    # Default architecture
    local arch="amd64"
    
    # Section tracking
    local section=""
    
    # Arrays for different setup sections
    local args_firstlogon=() args_logoncommands=() args_autologon=() args_specialcommands=() args_oobe=() args_useraccounts=()

    # Shell setup variables
    local registered_org="" registered_owner="" oem_name="" disable_auto_daylight=""
    local timezone="" bluetooth_icon="" computer_name="" slate_mode="" copy_profile=""
    local show_mail="" show_ie="" show_media_center="" show_media_player="" product_key=""
    local profiles_dir="" program_data="" color_depth="" dpi="" h_res="" v_res=""
    local refresh_rate="" recycle_url="" tradein_url="" support_provider="" support_app_url=""
    local support_url=""

    # Check for x86 architecture
    [[ "$1" == "x86" ]] && { arch="x86"; shift; }

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            firstlogoncommands|logoncommands|specialcommands|autologon|oobe|useraccounts) section="$1"; shift; continue ;;
            BluetoothTaskbarIconEnabled) shift; bluetooth_icon="$1" ;;
            ColorDepth) shift; color_depth="$1" ;;
            ComputerName) shift; computer_name="$1" ;;
            ConvertibleSlateModePromptPreference) shift; slate_mode="$1" ;;
            CopyProfile) shift; copy_profile="$1" ;;
            DPI) shift; dpi="$1" ;;
            DisableAutoDaylightTimeSet) shift; disable_auto_daylight="$1" ;;
            HorizontalResolution) shift; h_res="$1" ;;
            OEMName) shift; oem_name="$1" ;;
            ProductKey) shift; product_key="$1" ;;
            ProfilesDirectory) shift; profiles_dir="$1" ;;
            ProgramData) shift; program_data="$1" ;;
            RecycleURL) shift; recycle_url="$1" ;;
            RefreshRate) shift; refresh_rate="$1" ;;
            RegisteredOrganization) shift; registered_org="$1" ;;
            RegisteredOwner) shift; registered_owner="$1" ;;
            ShowInternetExplorer) shift; show_ie="$1" ;;
            ShowMediaCenter) shift; show_media_center="$1" ;;
            ShowWindowsMail) shift; show_mail="$1" ;;
            ShowWindowsMediaPlayer) shift; show_media_player="$1" ;;
            SupportAppURL) shift; support_app_url="$1" ;;
            SupportProvider) shift; support_provider="$1" ;;
            SupportURL) shift; support_url="$1" ;;
            TimeZone) shift; timezone="$1" ;;
            TradeInURL) shift; tradein_url="$1" ;;
            VerticalResolution) shift; v_res="$1" ;;
            *)
                # Store arguments in their respective sections
                [[ "$section" == "firstlogoncommands" ]] && args_firstlogon+=("$1")
                [[ "$section" == "logoncommands" ]] && args_logoncommands+=("$1")
                [[ "$section" == "specialcommands" ]] && args_specialcommands+=("$1")
                [[ "$section" == "autologon" ]] && args_autologon+=("$1")
                [[ "$section" == "useraccounts" ]] && args_useraccounts+=("$1")
                [[ "$section" == "oobe" ]] && args_oobe+=("$1")
                ;;
        esac
        shift
    done

    # Begin XML component
	echo -e "\t<component name=\"Microsoft-Windows-Shell-Setup\" processorArchitecture=\"$arch\" publicKeyToken=\"31bf3856ad364e35\" language=\"neutral\" versionScope=\"nonSxS\" xmlns:wcm=\"http://schemas.microsoft.com/WMIConfig/2002/State\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">"
	
    # Invoke respective setup functions if sections have arguments
    [[ ${#args_autologon[@]} -gt 0 ]] && windows-shell-setup-autologon "${args_autologon[@]}"
    [[ ${#args_oobe[@]} -gt 0 ]] && windows-shell-setup-oobe "${args_oobe[@]}"
    [[ ${#args_useraccounts[@]} -gt 0 ]] && windows-shell-setup-useraccounts "${args_useraccounts[@]}"
    [[ ${#args_firstlogon[@]} -gt 0 ]] && windows-shell-setup-firstlogoncommands "${args_firstlogon[@]}"
    [[ ${#args_logoncommands[@]} -gt 0 ]] && windows-shell-setup-logoncommands "${args_logoncommands[@]}"
	[[ ${#args_specialcommands[@]} -gt 0 ]] && windows-shell-setup-specialcommands "${args_specialcommands[@]}"

    # Output XML elements if values exist
    [[ -n "$registered_org" ]] && echo -e "\t\t<RegisteredOrganization>$registered_org</RegisteredOrganization>"
    [[ -n "$registered_owner" ]] && echo -e "\t\t<RegisteredOwner>$registered_owner</RegisteredOwner>"
    [[ -n "$oem_name" ]] && echo -e "\t\t<OEMName>$oem_name</OEMName>"
    [[ -n "$bluetooth_icon" ]] && echo -e "\t\t<BluetoothTaskbarIconEnabled>$bluetooth_icon</BluetoothTaskbarIconEnabled>"
    [[ -n "$computer_name" ]] && echo -e "\t\t<ComputerName>$computer_name</ComputerName>"
    [[ -n "$slate_mode" ]] && echo -e "\t\t<ConvertibleSlateModePromptPreference>$slate_mode</ConvertibleSlateModePromptPreference>"
    [[ -n "$copy_profile" ]] && echo -e "\t\t<CopyProfile>$copy_profile</CopyProfile>"
    [[ -n "$product_key" ]] && echo -e "\t\t<ProductKey>$product_key</ProductKey>"
    [[ -n "$timezone" ]] && echo -e "\t\t<TimeZone>$timezone</TimeZone>"
    [[ -n "$disable_auto_daylight" ]] && echo -e "\t\t<DisableAutoDaylightTimeSet>$disable_auto_daylight</DisableAutoDaylightTimeSet>"

    # Windows Features section
    if [[ -n "$show_mail" || -n "$show_ie" || -n "$show_media_center" || -n "$show_media_player" ]]; then
        echo -e "\t\t<WindowsFeatures>"
        [[ -n "$show_mail" ]] && echo -e "\t\t\t<ShowWindowsMail>$show_mail</ShowWindowsMail>"
        [[ -n "$show_ie" ]] && echo -e "\t\t\t<ShowInternetExplorer>$show_ie</ShowInternetExplorer>"
        [[ -n "$show_media_center" ]] && echo -e "\t\t\t<ShowMediaCenter>$show_media_center</ShowMediaCenter>"
        [[ -n "$show_media_player" ]] && echo -e "\t\t\t<ShowWindowsMediaPlayer>$show_media_player</ShowWindowsMediaPlayer>"
        echo -e "\t\t</WindowsFeatures>"
    fi

    # Folder locations section
    if [[ -n "$profiles_dir" || -n "$program_data" ]]; then
        echo -e "\t\t<FolderLocations>"
        [[ -n "$profiles_dir" ]] && echo -e "\t\t\t<ProfilesDirectory>$profiles_dir</ProfilesDirectory>"
        [[ -n "$program_data" ]] && echo -e "\t\t\t<ProgramData>$program_data</ProgramData>"
        echo -e "\t\t</FolderLocations>"
    fi

    # Display settings section
    if [[ -n "$color_depth" || -n "$dpi" || -n "$h_res" || -n "$v_res" || -n "$refresh_rate" ]]; then
        echo -e "\t\t<Display>"
        [[ -n "$color_depth" ]] && echo -e "\t\t\t<ColorDepth>$color_depth</ColorDepth>"
        [[ -n "$dpi" ]] && echo -e "\t\t\t<DPI>$dpi</DPI>"
        [[ -n "$h_res" ]] && echo -e "\t\t\t<HorizontalResolution>$h_res</HorizontalResolution>"
        [[ -n "$v_res" ]] && echo -e "\t\t\t<VerticalResolution>$v_res</VerticalResolution>"
        [[ -n "$refresh_rate" ]] && echo -e "\t\t\t<RefreshRate>$refresh_rate</RefreshRate>"
        echo -e "\t\t</Display>"
    fi

    # OEM Information section
    if [[ -n "$recycle_url" || -n "$tradein_url" || -n "$support_provider" || -n "$support_app_url" || -n "$support_url" ]]; then
        echo -e "\t\t<OEMInformation>"
        [[ -n "$recycle_url" ]] && echo -e "\t\t\t<RecycleURL>$recycle_url</RecycleURL>"
        [[ -n "$tradein_url" ]] && echo -e "\t\t\t<TradeInURL>$tradein_url</TradeInURL>"
        [[ -n "$support_provider" ]] && echo -e "\t\t\t<SupportProvider>$support_provider</SupportProvider>"
        [[ -n "$support_app_url" ]] && echo -e "\t\t\t<SupportAppURL>$support_app_url</SupportAppURL>"
        [[ -n "$support_url" ]] && echo -e "\t\t\t<SupportURL>$support_url</SupportURL>"
        echo -e "\t\t</OEMInformation>"
    fi

    # End XML component
    echo -e "\t</component>"
}