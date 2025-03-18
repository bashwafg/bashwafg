windows-international-core() {
    # Default architecture
    local arch="amd64"

    # Check if the first argument is "x86", update architecture and shift arguments
    [[ "$1" == "x86" ]] && arch="x86" && shift

    # Default locale settings
    local InputLocale="0409:00020409"
    local SystemLocale="en-US"
    local UserLocale="en-US"
    local UILanguage="en-US"
    local UILanguageFallback="en-GB"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            InputLocale|SystemLocale|UserLocale|UILanguage|UILanguageFallback) eval "$1=\$2"; shift 2 ;;
            Region) SystemLocale="$2"; UILanguage="$2"; UserLocale="$2"; shift 2 ;;
            *) echo "Unknown parameter: $1" >&2; return 1 ;;
        esac
    done

    # Generate XML output using multiple echo commands
    echo -e "\t\t<component name=\"Microsoft-Windows-International-Core\" processorArchitecture=\"$arch\" publicKeyToken=\"31bf3856ad364e35\" language=\"neutral\" versionScope=\"nonSxS\" xmlns:wcm=\"http://schemas.microsoft.com/WMIConfig/2002/State\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">"
    echo -e "\t\t\t<InputLocale>$InputLocale</InputLocale>"
    echo -e "\t\t\t<SystemLocale>$SystemLocale</SystemLocale>"
    echo -e "\t\t\t<UILanguage>$UILanguage</UILanguage>"
    echo -e "\t\t\t<UILanguageFallback>$UILanguageFallback</UILanguageFallback>"
    echo -e "\t\t\t<UserLocale>$UserLocale</UserLocale>"
    echo -e "\t\t</component>"
}
