windows-international-core-pe() {
    # Default architecture
    local arch="amd64"

    # Check if first argument is "x86", set architecture accordingly and shift arguments
    [[ "$1" == "x86" ]] && arch="x86" && shift

    # Default locale settings
    local SetupUILanguage="en-US" InputLocale="0409:00020409"
    local SystemLocale="en-US" UserLocale="en-US"
    local UILanguage="en-US" UILanguageFallback="en-GB"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            SetupUILanguage|InputLocale|SystemLocale|UserLocale|UILanguage|UILanguageFallback) eval "$1=\$2"; shift 2 ;;
            Region) SetupUILanguage="$2"; SystemLocale="$2"; UILanguage="$2"; UserLocale="$2"; shift 2 ;;
            *) echo "Unknown parameter: $1" >&2; return 1 ;;
        esac
    done

    # Generate XML output using multiple echo commands
    echo -e "\t\t<component name=\"Microsoft-Windows-International-Core-WinPE\" processorArchitecture=\"$arch\" publicKeyToken=\"31bf3856ad364e35\" language=\"neutral\" versionScope=\"nonSxS\" xmlns:wcm=\"http://schemas.microsoft.com/WMIConfig/2002/State\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">"
    echo -e "\t\t\t<SetupUILanguage>"
    echo -e "\t\t\t\t<UILanguage>$SetupUILanguage</UILanguage>"
    echo -e "\t\t\t</SetupUILanguage>"
    echo -e "\t\t\t<InputLocale>$InputLocale</InputLocale>"
    echo -e "\t\t\t<SystemLocale>$SystemLocale</SystemLocale>"
    echo -e "\t\t\t<UILanguage>$UILanguage</UILanguage>"
    echo -e "\t\t\t<UILanguageFallback>$UILanguageFallback</UILanguageFallback>"
    echo -e "\t\t\t<UserLocale>$UserLocale</UserLocale>"
    echo -e "\t\t</component>"
}
