windows-shell-setup-localaccount() {
    # Default values
    local name="" password="" plaintext="true"
    local description="" display_name="" group="Users"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            Name) shift; name="$1" ;;
            Password) shift; password="$1" ;;
            PlainText) shift; plaintext="$1" ;;
            Description) shift; description="$1" ;;
            DisplayName) shift; display_name="$1" ;;
            Group) shift; group="$1" ;;
        esac
        shift
    done

    # If no name is provided, exit the function
    [[ -z "$name" ]] && return

    # Set display name to name if it's not provided
    [[ -z "$display_name" ]] && display_name="$name"

    # Generate XML output
    echo -e "\t\t\t\t<LocalAccount wcm:action=\"add\">"

    [[ -n "$password" ]] && {
        echo -e "\t\t\t\t\t<Password>"
        echo -e "\t\t\t\t\t\t<Value>$password</Value>"
        echo -e "\t\t\t\t\t\t<PlainText>$plaintext</PlainText>"
        echo -e "\t\t\t\t\t</Password>"
    }

    [[ -n "$description" ]] && echo -e "\t\t\t\t\t<Description>$description</Description>"

    echo -e "\t\t\t\t\t<DisplayName>$display_name</DisplayName>"
    echo -e "\t\t\t\t\t<Group>$group</Group>"
    echo -e "\t\t\t\t\t<Name>$name</Name>"
    echo -e "\t\t\t\t</LocalAccount>"
}