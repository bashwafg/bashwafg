windows-shell-setup-autologon() {
    # Initialize variables
    local username="" password="" plaintext="true"
    local enabled="true" domain="" logon_count=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            Username) shift; username="$1" ;;
            Password) shift; password="$1" ;;
            PlainText) shift; plaintext="$1" ;;
            Enabled) shift; enabled="$1" ;;
            Domain) shift; domain="$1" ;;
            LogonCount) shift; logon_count="$1" ;;
        esac
        shift
    done

    # If username is empty, return (no output)
    [[ -z "$username" ]] && return

    # Start XML output
    echo -e "\t\t<AutoLogon>"

    # Include password block if password is set
    [[ -n "$password" ]] && {
        echo -e "\t\t\t<Password>"
        echo -e "\t\t\t\t<Value>$password</Value>"
        echo -e "\t\t\t\t<PlainText>$plaintext</PlainText>"
        echo -e "\t\t\t</Password>"
    }

    # Include domain if set
    [[ -n "$domain" ]] && echo -e "\t\t\t<Domain>$domain</Domain>"

    # Always include Enabled field
    echo -e "\t\t\t<Enabled>$enabled</Enabled>"

    # Include LogonCount if set
    [[ -n "$logon_count" ]] && echo -e "\t\t\t<LogonCount>$logon_count</LogonCount>"

    # Always include Username field
    echo -e "\t\t\t<Username>$username</Username>"
    echo -e "\t\t</AutoLogon>"
}