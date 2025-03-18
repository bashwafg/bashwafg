windows-setup() {
    # Default architecture
    local arch="amd64"

    # Initialize argument arrays
    local disk_args=()
    local imageinstall_args=("osimage")
    local userdata_args=()
    local sync_args=()
    local async_args=()
    local remainder_args=()

    # Check if first argument is "x86", set architecture accordingly and shift arguments
    if [[ "$1" == "x86" ]]; then
        arch="x86"
        shift
    fi

    # Print the XML component opening tag
    printf '\t\t<component name="Microsoft-Windows-Setup" processorArchitecture="%s" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">\n' "$arch"

    # Parse input arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            disk)
                shift
                while [[ $# -gt 0 && ! "$1" =~ ^(userdata|imageinstall|addrunsynchronous|addrunasynchronous|remainder)$ ]]; do
                    disk_args+=("$1")
                    shift
                done
                ;;
            userdata)
                shift
                while [[ $# -gt 0 && ! "$1" =~ ^(disk|imageinstall|addrunsynchronous|addrunasynchronous|remainder)$ ]]; do
                    userdata_args+=("$1")
                    shift
                done
                ;;
            imageinstall)
                shift
                imageinstall_args=()
                while [[ $# -gt 0 && ! "$1" =~ ^(disk|userdata|addrunsynchronous|addrunasynchronous|remainder)$ ]]; do
                    imageinstall_args+=("$1")
                    shift
                done
                ;;
            addrunsynchronous)
                shift
                while [[ $# -gt 0 && ! "$1" =~ ^(disk|userdata|imageinstall|addrunasynchronous|remainder)$ ]]; do
                    sync_args+=("$1")
                    shift
                done
                ;;
            addrunasynchronous)
                shift
                while [[ $# -gt 0 && ! "$1" =~ ^(disk|userdata|imageinstall|addrunsynchronous|remainder)$ ]]; do
                    async_args+=("$1")
                    shift
                done
                ;;
            remainder)
                shift
                while [[ $# -gt 0 && ! "$1" =~ ^(disk|userdata|imageinstall|addrunsynchronous|addrunasynchronous)$ ]]; do
                    remainder_args+=("$1")
                    shift
                done
                ;;
            *)
                shift
                ;;
        esac
    done

    # Set default disk arguments if none are provided
    if [[ ${#disk_args[@]} -eq 0 ]]; then
        disk_args=("adddisk" "createpartitions" "$([[ "$arch" == "x86" ]] && echo "BIOS" || echo "EFI")" "modifypartitions" "$([[ "$arch" == "x86" ]] && echo "BIOS" || echo "EFI")")
    fi
    windows-setup-disk-configuration "${disk_args[@]}"

    # Set default imageinstall arguments if none are provided
    if [[ ${#imageinstall_args[@]} -eq 0 ]]; then
        imageinstall_args=("osimage")
    fi
    windows-setup-imageinstall "${imageinstall_args[@]}"

    # Process userdata arguments
    windows-setup-userdata "${userdata_args[@]}"

    # Process synchronous commands if any exist
    [[ ${#sync_args[@]} -gt 0 ]] && windows-setup-addrunsynchronous "${sync_args[@]}"

    # Process asynchronous commands if any exist
    [[ ${#async_args[@]} -gt 0 ]] && windows-setup-addrunasynchronous "${async_args[@]}"

    # Process remainder arguments if any exist
    [[ ${#remainder_args[@]} -gt 0 ]] && windows-setup-remainder "${remainder_args[@]}"

    # Print the XML component closing tag
    printf '\t\t</component>\n'
}