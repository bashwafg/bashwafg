windows-shell-setup-domainaccount() {
    # Default values
    local name=""
    local group="Users"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            Name) shift; name="$1" ;;
            Group) shift; group="$1" ;;
        esac
        shift
    done

    # If no name is provided, exit the function
    [[ -z "$name" ]] && return

    # Generate XML output
    echo -e "\t\t\t\t\t<DomainAccount wcm:action=\"add\">"
    echo -e "\t\t\t\t\t\t<Name>$name</Name>"
    echo -e "\t\t\t\t\t\t<Group>$group</Group>"
    echo -e "\t\t\t\t\t</DomainAccount>"
}