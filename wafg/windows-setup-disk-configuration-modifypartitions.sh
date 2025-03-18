windows-setup-disk-configuration-modifypartitions() {
    local args=()
    local order=1
    local max_order=0

    echo -e "\t\t\t\t\t<ModifyPartitions>"

    while [[ $# -gt 0 ]]; do
        if [[ "$1" == "add" ]]; then
            if [[ ${#args[@]} -gt 0 ]]; then
                # Ensure 'Order' is in args before processing the partition
                printf '%s\n' "${args[@]}" | grep -qE '^Order$' || args+=(Order "$order") && ((order++))
                windows-setup-disk-configuration-modifypartition "${args[@]}"
                args=()
            fi
        else
            [[ "$1" == "Order" ]] && max_order=$(( $2 > max_order ? $2 : max_order ))
            args+=("$1")
        fi
        shift
    done

    # Process remaining args if any
    if [[ ${#args[@]} -gt 0 ]]; then
        printf '%s\n' "${args[@]}" | grep -qE '^Order$' || args+=(Order "$order")
        windows-setup-disk-configuration-modifypartition "${args[@]}"
    fi

    echo -e "\t\t\t\t\t</ModifyPartitions>"
}