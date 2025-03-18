windows-security-spp-ux() { local arch="amd64" skip_auto_activation="true"; [[ "$1" == "x86" ]] && { arch="x86"; shift; }; while [[ $# -gt 0 ]]; do case "$1" in SkipAutoActivation) shift; skip_auto_activation="$1" ;; esac; shift; done; [[ "$skip_auto_activation" == "" ]] && return; echo -e "\t\t<component name=\"Microsoft-Windows-Security-SPP-UX\" processorArchitecture=\"$arch\" publicKeyToken=\"31bf3856ad364e35\" language=\"neutral\" versionScope=\"nonSxS\" xmlns:wcm=\"http://schemas.microsoft.com/WMIConfig/2002/State\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n\t\t\t<SkipAutoActivation>$skip_auto_activation</SkipAutoActivation>\n\t\t</component>"; }