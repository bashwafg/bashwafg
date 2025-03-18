windows-setup-userdata() {
    # Default values
    local AcceptEula="true"
    local FullName="user"
    local Organization=""
    local Key="W269N-WFGWX-YVC9B-4J6C9-T83GX"
    local WillShowUI="Never"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            AcceptEula|FullName|Organization|Key|WillShowUI) eval "$1=\$2"; shift 2 ;;
            *) echo "Unknown parameter: $1" >&2; return 1 ;;
        esac
    done

    # Generate XML output
    echo -e "\t\t\t<UserData>"
    echo -e "\t\t\t\t<ProductKey>"
    echo -e "\t\t\t\t\t<Key>$Key</Key>"
    [[ -n "$WillShowUI" ]] && echo -e "\t\t\t\t\t<WillShowUI>$WillShowUI</WillShowUI>"
    echo -e "\t\t\t\t</ProductKey>"
    echo -e "\t\t\t\t<AcceptEula>$AcceptEula</AcceptEula>"
    echo -e "\t\t\t\t<FullName>$FullName</FullName>"
    echo -e "\t\t\t\t<Organization>$Organization</Organization>"
    echo -e "\t\t\t</UserData>"
}