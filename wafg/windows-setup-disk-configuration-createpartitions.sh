windows-setup-disk-configuration-createpartitions() {
    local args=()
    local order=1
    local max_order=0

    # Start XML CreatePartitions block
    echo -e "\t\t\t\t\t<CreatePartitions>"

    # Iterate over the input arguments
    while [[ $# -gt 0 ]]; do
        if [[ "$1" == "add" ]]; then
            # Process previous partition data if args is not empty
            if [[ ${#args[@]} -gt 0 ]]; then
                printf '%s\n' "${args[@]}" | grep -qE '^Order$' || args+=(Order "$order") && ((order++))
                windows-setup-disk-configuration-createpartition "${args[@]}"
                args=()
            fi
        else
            [[ "$1" == "Order" ]] && max_order=$(( $2 > max_order ? $2 : max_order ))
            args+=("$1")
        fi
        shift
    done

    # Process any remaining partition data
    if [[ ${#args[@]} -gt 0 ]]; then
        printf '%s\n' "${args[@]}" | grep -qE '^Order$' || args+=(Order "$order")
        windows-setup-disk-configuration-createpartition "${args[@]}"
    fi

    # End XML CreatePartitions block
    echo -e "\t\t\t\t\t</CreatePartitions>"
}