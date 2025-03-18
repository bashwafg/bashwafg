windows-sqmapi() {
    # Default architecture and CEIP (Customer Experience Improvement Program) setting
    local arch="amd64"
    local ceip_enabled="0"

    # Check if the first argument is "x86", set architecture accordingly and shift arguments
    if [[ "$1" == "x86" ]]; then
        arch="x86"
        shift
    fi

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            CEIPEnabled) shift; ceip_enabled="$1" ;;
        esac
        shift
    done

    # If CEIPEnabled is empty, return without output
    [[ -z "$ceip_enabled" ]] && return

    # Generate XML output
    echo -e "\t\t<component name=\"Microsoft-Windows-SQMApi\" processorArchitecture=\"$arch\" publicKeyToken=\"31bf3856ad364e35\" language=\"neutral\" versionScope=\"nonSxS\" xmlns:wcm=\"http://schemas.microsoft.com/WMIConfig/2002/State\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">"
    echo -e "\t\t\t<CEIPEnabled>$ceip_enabled</CEIPEnabled>"
    echo -e "\t\t</component>"
}