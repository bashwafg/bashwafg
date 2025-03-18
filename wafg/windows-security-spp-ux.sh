windows-security-spp-ux() {
    # Default values
    local arch="amd64"
    local skip_auto_activation="true"

    # Check if first argument is "x86", set architecture accordingly and shift arguments
    if [[ "$1" == "x86" ]]; then
        arch="x86"
        shift
    fi

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            SkipAutoActivation) shift; skip_auto_activation="$1" ;;
        esac
        shift
    done

    # If skip_auto_activation is empty, exit function
    [[ -z "$skip_auto_activation" ]] && return

    # Generate XML output
    echo -e "\t\t<component name=\"Microsoft-Windows-Security-SPP-UX\" processorArchitecture=\"$arch\" publicKeyToken=\"31bf3856ad364e35\" language=\"neutral\" versionScope=\"nonSxS\" xmlns:wcm=\"http://schemas.microsoft.com/WMIConfig/2002/State\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">"
    echo -e "\t\t\t<SkipAutoActivation>$skip_auto_activation</SkipAutoActivation>"
    echo -e "\t\t</component>"
}