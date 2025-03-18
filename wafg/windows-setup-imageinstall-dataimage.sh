windows-setup-imageinstall-dataimage() {
    # Set default order if not defined
    [[ -z "$DATAIMAGE_ORDER" ]] && DATAIMAGE_ORDER=1

    # Initialize variables
    local DiskID="" PartitionID="" Domain="" Password="" Username="" Path=""
    local MetaKey="" MetaValue="" Order="$DATAIMAGE_ORDER"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            DiskID|PartitionID|Order) eval "$1=\$2"; shift 2 ;;
            Domain|Password|Username|Path) eval "$1=\$2"; shift 2 ;;
            MetaData) MetaKey="$2"; MetaValue="$3"; shift 3 ;;
            *) echo "Unknown parameter: $1" >&2; return 1 ;;
        esac
    done

    # Increment order for next use
    ((DATAIMAGE_ORDER++))

    # Generate XML output
    printf '\t\t\t\t<DataImage wcm:action="add">\n'

    # InstallTo section (if DiskID or PartitionID is specified)
    if [[ -n "$DiskID" || -n "$PartitionID" ]]; then
        printf '\t\t\t\t\t<InstallTo>\n'
        [[ -n "$DiskID" ]] && printf '\t\t\t\t\t\t<DiskID>%s</DiskID>\n' "$DiskID"
        [[ -n "$PartitionID" ]] && printf '\t\t\t\t\t\t<PartitionID>%s</PartitionID>\n' "$PartitionID"
        printf '\t\t\t\t\t</InstallTo>\n'
    fi

    # InstallFrom section (if Path is specified)
    if [[ -n "$Path" ]]; then
        printf '\t\t\t\t\t<InstallFrom>\n'

        # Credentials section (if any credential fields are specified)
        if [[ -n "$Username" || -n "$Password" || -n "$Domain" ]]; then
            printf '\t\t\t\t\t\t<Credentials>\n'
            [[ -n "$Domain" ]] && printf '\t\t\t\t\t\t\t<Domain>%s</Domain>\n' "$Domain"
            [[ -n "$Username" ]] && printf '\t\t\t\t\t\t\t<Username>%s</Username>\n' "$Username"
            [[ -n "$Password" ]] && printf '\t\t\t\t\t\t\t<Password>%s</Password>\n' "$Password"
            printf '\t\t\t\t\t\t</Credentials>\n'
        fi

        printf '\t\t\t\t\t\t<Path>%s</Path>\n' "$Path"

        # MetaData section (if both MetaKey and MetaValue are specified)
        if [[ -n "$MetaKey" && -n "$MetaValue" ]]; then
            printf '\t\t\t\t\t\t<MetaData wcm:action="add">\n'
            printf '\t\t\t\t\t\t\t<Key>%s</Key>\n' "$MetaKey"
            printf '\t\t\t\t\t\t\t<Value>%s</Value>\n' "$MetaValue"
            printf '\t\t\t\t\t\t</MetaData>\n'
        fi

        printf '\t\t\t\t\t</InstallFrom>\n'
    fi

    # Order section
    printf '\t\t\t\t\t<Order>%s</Order>\n' "$Order"
    printf '\t\t\t\t</DataImage>\n'
}