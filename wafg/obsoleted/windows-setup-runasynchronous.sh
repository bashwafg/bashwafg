windows-setup-runasynchronous() {
    # Initialize RUNASYNC_ORDER if not already set
    [[ -z "$RUNASYNC_ORDER" ]] && RUNASYNC_ORDER=1

    # Default values for parameters
    local Order="$RUNASYNC_ORDER" Path="" Description=""
    local Domain="" UserName="" Password=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            Order|Path|Description|Domain|UserName|Password) eval "$1=\$2"; shift 2 ;;
            *) echo "Unknown parameter: $1" >&2; return 1 ;;
        esac
    done

    # Increment RUNASYNC_ORDER for next call
    ((RUNASYNC_ORDER++))

    # Print the XML structure
    printf '\t\t\t\t<RunAsynchronousCommand>\n'
    printf '\t\t\t\t\t<Order>%s</Order>\n' "$Order"
    printf '\t\t\t\t\t<Path>%s</Path>\n' "$Path"

    # Optional fields
    [[ -n "$Description" ]] && printf '\t\t\t\t\t<Description>%s</Description>\n' "$Description"

    # Handle credentials if any are provided
    if [[ -n "$Domain" || -n "$UserName" || -n "$Password" ]]; then
        printf '\t\t\t\t\t<Credentials>\n'
        [[ -n "$Domain" ]] && printf '\t\t\t\t\t\t<Domain>%s</Domain>\n' "$Domain"
        [[ -n "$UserName" ]] && printf '\t\t\t\t\t\t<UserName>%s</UserName>\n' "$UserName"
        [[ -n "$Password" ]] && printf '\t\t\t\t\t\t<Password>%s</Password>\n' "$Password"
        printf '\t\t\t\t\t</Credentials>\n'
    fi

    printf '\t\t\t\t</RunAsynchronousCommand>\n'
}