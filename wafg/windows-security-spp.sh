windows-security-spp() {
    # Default values
    local arch="amd64"
    local skip_rearm="1"

    # Check if first argument is "x86", set architecture accordingly and shift arguments
    if [[ "$1" == "x86" ]]; then
        arch="x86"
        shift
    fi

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            SkipRearm) shift; skip_rearm="$1" ;;
        esac
        shift
    done

    # If skip_rearm is empty, exit the function
    [[ -z "$skip_rearm" ]] && return

    # Generate XML output
    echo -e "\t\t<component name=\"Microsoft-Windows-Security-SPP\" processorArchitecture=\"$arch\" publicKeyToken=\"31bf3856ad364e35\" language=\"neutral\" versionScope=\"nonSxS\" xmlns:wcm=\"http://schemas.microsoft.com/WMIConfig/2002/State\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">"
    echo -e "\t\t\t<SkipRearm>$skip_rearm</SkipRearm>"
    echo -e "\t\t</component>"
}