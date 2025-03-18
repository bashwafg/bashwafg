cmd_unattend_clear() {
    local pass="${1:-}"         # windowspe, generalize, specialize, etc.
    local component="${2:-}"    # setup, shell, deploy
    local type="${3:-}"         # runsync or runasync

    # List of all valid passes
    local passes=(windowspe generalize specialize offlineservicing oobesystem auditsystem audituser)
    
    # List of all valid components
    local components=(setup shell deploy)
    
    # List of all valid types
    local types=(sync async)

    # Function to clear an entire pseudoarray
    clear_pseudoarray() {
        local array_prefix="$1"
        local i=0

        # Check if pseudoarray exists by checking the first index
        if [[ -n "$(eval echo "\${${array_prefix}_0_command+set}")" ]]; then
            while [[ -n "$(eval echo "\${${array_prefix}_${i}_command+set}")" ]]; do
                unset "${array_prefix}_${i}_command"
                unset "${array_prefix}_${i}_description"
                unset "${array_prefix}_${i}_order"
                unset "${array_prefix}_${i}_domain"
                unset "${array_prefix}_${i}_user"
                unset "${array_prefix}_${i}_pass"
                unset "${array_prefix}_${i}_willreboot"
                unset "${array_prefix}_${i}_requiresinput"
                ((i++))
            done
            unset "${array_prefix}_ubound"
        fi
    }

    # If no arguments, clear all pseudoarrays
    if [[ -z "$pass" ]]; then
        for p in "${passes[@]}"; do
            for c in "${components[@]}"; do
                for t in "${types[@]}"; do
                    clear_pseudoarray "cmd_${p}_${c}_${t}"
                done
            done
        done
        return
    fi

    # Validate pass
    if [[ ! " ${passes[*]} " =~ " ${pass} " ]]; then
        echo "Error: Invalid pass '$pass'. Valid options: ${passes[*]}" >&2
        return 1
    fi

    # If only pass is provided, clear all pseudoarrays for that pass
    if [[ -z "$component" ]]; then
        for c in "${components[@]}"; do
            for t in "${types[@]}"; do
                clear_pseudoarray "cmd_${pass}_${c}_${t}"
            done
        done
        return
    fi

    # Validate component
    if [[ ! " ${components[*]} " =~ " ${component} " ]]; then
        echo "Error: Invalid component '$component'. Valid options: ${components[*]}" >&2
        return 1
    fi

    # If only pass and component are provided, clear all pseudoarrays for that component
    if [[ -z "$type" ]]; then
        for t in "${types[@]}"; do
            clear_pseudoarray "cmd_${pass}_${component}_${t}"
        done
        return
    fi

    # Validate type (runsync/runasync)
    if [[ ! " ${types[*]} " =~ " ${type} " ]]; then
        echo "Error: Invalid type '$type'. Valid options: ${types[*]}" >&2
        return 1
    fi

    # If all three arguments are provided, clear the specific pseudoarray
    clear_pseudoarray "cmd_${pass}_${component}_${type}"
}