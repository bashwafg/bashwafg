windows-setup-imageinstall-osimage() {
    # Default values
    local InstallToAvailablePartition="true"
    local DiskID="" PartitionID="" Domain="" Password="" Username="" Path=""
    local MetaKey="" MetaValue="" WillShowUI="Never"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            InstallToAvailablePartition|DiskID|PartitionID|WillShowUI) eval "$1=\$2"; shift 2 ;;
            Domain|Password|Username|Path) eval "$1=\$2"; shift 2 ;;
            MetaData) MetaKey="$2"; MetaValue="$3"; shift 3 ;;
            *) echo "Unknown parameter: $1" >&2; return 1 ;;
        esac
    done

    # Begin XML output
    printf '\t\t\t\t<OSImage>\n'

    # InstallFrom Section
    if [[ -n "$Path" || (-n "$MetaKey" && -n "$MetaValue") ]]; then
        printf '\t\t\t\t\t<InstallFrom>\n'

        # Credentials Section
        if [[ -n "$Username" || -n "$Password" || -n "$Domain" ]]; then
            printf '\t\t\t\t\t\t<Credentials>\n'
            [[ -n "$Domain" ]] && printf '\t\t\t\t\t\t\t<Domain>%s</Domain>\n' "$Domain"
            [[ -n "$Username" ]] && printf '\t\t\t\t\t\t\t<Username>%s</Username>\n' "$Username"
            [[ -n "$Password" ]] && printf '\t\t\t\t\t\t\t<Password>%s</Password>\n' "$Password"
            printf '\t\t\t\t\t\t</Credentials>\n'
        fi

        # Path Section
        [[ -n "$Path" ]] && printf '\t\t\t\t\t\t<Path>%s</Path>\n' "$Path"

        # MetaData Section
        if [[ -n "$MetaKey" && -n "$MetaValue" ]]; then
            printf '\t\t\t\t\t\t<MetaData wcm:action="add">\n'
            printf '\t\t\t\t\t\t\t<Key>%s</Key>\n' "$MetaKey"
            printf '\t\t\t\t\t\t\t<Value>%s</Value>\n' "$MetaValue"
            printf '\t\t\t\t\t\t</MetaData>\n'
        fi

        printf '\t\t\t\t\t</InstallFrom>\n'
    fi

    # InstallTo Section
    if [[ -n "$DiskID" || -n "$PartitionID" ]]; then
        printf '\t\t\t\t\t<InstallTo>\n'
        [[ -n "$DiskID" ]] && printf '\t\t\t\t\t\t<DiskID>%s</DiskID>\n' "$DiskID"
        [[ -n "$PartitionID" ]] && printf '\t\t\t\t\t\t<PartitionID>%s</PartitionID>\n' "$PartitionID"
        printf '\t\t\t\t\t</InstallTo>\n'
    fi

    # InstallToAvailablePartition & WillShowUI
    printf '\t\t\t\t\t<InstallToAvailablePartition>%s</InstallToAvailablePartition>\n' "$InstallToAvailablePartition"
    [[ -n "$WillShowUI" ]] && printf '\t\t\t\t\t<WillShowUI>%s</WillShowUI>\n' "$WillShowUI"

    # Close XML
    printf '\t\t\t\t</OSImage>\n'
}