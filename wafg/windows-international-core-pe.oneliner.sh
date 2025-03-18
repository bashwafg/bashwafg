windows-international-core-pe() { local arch="amd64"; [[ "$1" == "x86" ]] && arch="x86" && shift; local SetupUILanguage="en-US" InputLocale="0409:00020409" SystemLocale="en-US" UserLocale="en-US" UILanguage="en-US" UILanguageFallback="en-GB"; while [[ $# -gt 0 ]]; do case "$1" in SetupUILanguage|InputLocale|SystemLocale|UserLocale|UILanguage|UILanguageFallback) eval "$1=\$2"; shift 2 ;; Region) SetupUILanguage="$2"; SystemLocale="$2"; UILanguage="$2"; UserLocale="$2"; shift 2 ;; *) echo "Unknown parameter: $1" >&2; return 1 ;; esac; done; echo -e "\t\t<component name=\"Microsoft-Windows-International-Core-WinPE\" processorArchitecture=\"$arch\" publicKeyToken=\"31bf3856ad364e35\" language=\"neutral\" versionScope=\"nonSxS\" xmlns:wcm=\"http://schemas.microsoft.com/WMIConfig/2002/State\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n\t\t\t<SetupUILanguage>\n\t\t\t\t<UILanguage>$SetupUILanguage</UILanguage>\n\t\t\t</SetupUILanguage>\n\t\t\t<InputLocale>$InputLocale</InputLocale>\n\t\t\t<SystemLocale>$SystemLocale</SystemLocale>\n\t\t\t<UILanguage>$UILanguage</UILanguage>\n\t\t\t<UILanguageFallback>$UILanguageFallback</UILanguageFallback>\n\t\t\t<UserLocale>$UserLocale</UserLocale>\n\t\t</component>"; }