windows-setup-runsynchronous() {
    # Set default order if not already set
    [[ -z "$RUNSYNC_ORDER" ]] && RUNSYNC_ORDER=1
    local Order="$RUNSYNC_ORDER"
    
    # Initialize variables
    local Path="" Description="" Domain="" UserName="" Password=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            Order|Path|Description|Domain|UserName|Password) eval "$1=\$2"; shift 2 ;;
            *) echo "Unknown parameter: $1" >&2; return 1 ;;
        esac
    done

    # Increment the RUNSYNC_ORDER counter
    ((RUNSYNC_ORDER++))

    # Generate XML output
    printf '\t\t\t\t<RunSynchronousCommand>\n'
    printf '\t\t\t\t\t<Order>%s</Order>\n' "$Order"
    printf '\t\t\t\t\t<Path>%s</Path>\n' "$Path"

    # Optional fields
    [[ -n "$Description" ]] && printf '\t\t\t\t\t<Description>%s</Description>\n' "$Description"
    
    if [[ -n "$Domain" || -n "$UserName" || -n "$Password" ]]; then
        printf '\t\t\t\t\t<Credentials>\n'
        [[ -n "$Domain" ]] && printf '\t\t\t\t\t\t<Domain>%s</Domain>\n' "$Domain"
        [[ -n "$UserName" ]] && printf '\t\t\t\t\t\t<UserName>%s</UserName>\n' "$UserName"
        [[ -n "$Password" ]] && printf '\t\t\t\t\t\t<Password>%s</Password>\n' "$Password"
        printf '\t\t\t\t\t</Credentials>\n'
    fi

    printf '\t\t\t\t</RunSynchronousCommand>\n'
}