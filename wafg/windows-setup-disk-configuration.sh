windows-setup-disk-configuration() {
    # Default values
    local disk_id=0 wipe_disk="false"
    local create_args=() modify_args=()
    local collecting_create=0 collecting_modify=0

    # Process arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            adddisk)
                # If there are collected partitions, process them before resetting
                if [[ ${#create_args[@]} -gt 0 || ${#modify_args[@]} -gt 0 ]]; then
                    echo -e "\t\t\t<DiskConfiguration>"
                    echo -e "\t\t\t\t<Disk wcm:action=\"add\">"
                    echo -e "\t\t\t\t\t<DiskID>$disk_id</DiskID>"
                    echo -e "\t\t\t\t\t<WillWipeDisk>$wipe_disk</WillWipeDisk>"

                    [[ ${#create_args[@]} -gt 0 ]] && windows-setup-disk-configuration-createpartitions "${create_args[@]}"
                    [[ ${#modify_args[@]} -gt 0 ]] && windows-setup-disk-configuration-modifypartitions "${modify_args[@]}"

                    echo -e "\t\t\t\t</Disk>"
                    echo -e "\t\t\t</DiskConfiguration>"

                    # Reset variables
                    create_args=()
                    modify_args=()
                    ((disk_id++))
                    wipe_disk="false"
                fi
                collecting_create=0
                collecting_modify=0
                ;;
            
            DiskID)
                shift
                disk_id="$1"
                ;;

            WillWipeDisk)
                shift
                wipe_disk="$1"
                ;;

            createpartitions)
                shift
                collecting_create=1
                collecting_modify=0

                # Handle predefined partition setups for EFI/BIOS
                if [[ "$1" == "EFI" ]]; then
                    create_args+=(
                        add Order 3 Type Primary Size 500
                        add Order 1 Type EFI Size 500
                        add Order 2 Type MSR Size 128
                        add Order 4 Type Primary Extend true
                    )
                    shift
                elif [[ "$1" == "BIOS" ]]; then
                    create_args+=(
                        add Order 1 Type Primary Size 500
                        add Extend true Order 2 Type Primary
                    )
                    shift
                fi

                # Collect additional partition arguments
                while [[ $# -gt 0 && "$1" != "modifypartitions" && "$1" != "adddisk" ]]; do
                    create_args+=("$1")
                    shift
                done
                continue
                ;;

            modifypartitions)
                shift
                collecting_create=0
                collecting_modify=1

                # Handle predefined partition modifications for EFI/BIOS
                if [[ "$1" == "EFI" ]]; then
                    modify_args+=(
                        add Order 3 PartitionID 3 Label WINRE Format NTFS TypeID "DE94BBA4-06D1-4D40-A16A-BFD50179D6AC"
                        add Order 1 PartitionID 1 Label System Format FAT32
                        add Order 2 PartitionID 2
                        add Order 4 PartitionID 4 Label OS Letter C Format NTFS
                    )
                    shift
                elif [[ "$1" == "BIOS" ]]; then
                    modify_args+=(
                        add Active true Format NTFS Label "System Reserved" Order 1 PartitionID 1 TypeID 0x27
                        add Active true Format NTFS Label OS Letter C Order 2 PartitionID 2
                    )
                    shift
                fi

                # Collect additional partition arguments
                while [[ $# -gt 0 && "$1" != "createpartitions" && "$1" != "adddisk" ]]; do
                    modify_args+=("$1")
                    shift
                done
                continue
                ;;

            add)
                [[ $collecting_create -eq 1 ]] && create_args+=(add)
                [[ $collecting_modify -eq 1 ]] && modify_args+=(add)
                ;;

            *)
                [[ $collecting_create -eq 1 ]] && create_args+=("$1")
                [[ $collecting_modify -eq 1 ]] && modify_args+=("$1")
                ;;
        esac
        shift
    done

    # Process any remaining partitions after the last disk
    if [[ ${#create_args[@]} -gt 0 || ${#modify_args[@]} -gt 0 ]]; then
        echo -e "\t\t\t<DiskConfiguration>"
        echo -e "\t\t\t\t<Disk wcm:action=\"add\">"
        echo -e "\t\t\t\t\t<DiskID>$disk_id</DiskID>"
        echo -e "\t\t\t\t\t<WillWipeDisk>$wipe_disk</WillWipeDisk>"

        [[ ${#create_args[@]} -gt 0 ]] && windows-setup-disk-configuration-createpartitions "${create_args[@]}"
        [[ ${#modify_args[@]} -gt 0 ]] && windows-setup-disk-configuration-modifypartitions "${modify_args[@]}"

        echo -e "\t\t\t\t</Disk>"
        echo -e "\t\t\t</DiskConfiguration>"
    fi
}
