windows-lua-settings() {
    # Default architecture
    local arch="amd64"
    local enable_lua=""

    # Check if first argument is "x86", set architecture accordingly and shift arguments
    if [[ "$1" == "x86" ]]; then
        arch="x86"
        shift
    fi

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            EnableLUA) shift; enable_lua="$1" ;;
        esac
        shift
    done

    # If EnableLUA is not set, exit
    [[ -z "$enable_lua" ]] && return

    # Generate XML output using multiple echo commands
    echo -e "\t\t<component name=\"Microsoft-Windows-LUA-Settings\" processorArchitecture=\"$arch\" publicKeyToken=\"31bf3856ad364e35\" language=\"neutral\" versionScope=\"nonSxS\" xmlns:wcm=\"http://schemas.microsoft.com/WMIConfig/2002/State\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">"
    echo -e "\t\t\t<EnableLUA>$enable_lua</EnableLUA>"
    echo -e "\t\t</component>"
}