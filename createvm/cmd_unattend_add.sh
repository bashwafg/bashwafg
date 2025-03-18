cmd_unattend_add() {
    # Defaults
    local pass="oobesystem"  # Default pass
    local component="shell"  # Default component (since most commands are here)
    local type="async"        # Default type (sync)

    # Optional parameters
    local command=""
    local description=""
    local order=""
    local domain=""
    local user=""
    local pass=""
    local willreboot=""
    local requiresinput=""

    # Auto-increment index
    local index_var=""
    local index=0

    # Process arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            windowspe|generalize|specialize|offlineservicing|oobesystem|auditsystem|audituser)
                pass="$1" ;;
            sync|async)
                type="$1" ;;  # Keeps sync/async without "run"
            domain|user|pass|willreboot|requiresinput)
                local key="$1"
                shift
                eval "$key=\"$1\"" ;;  # Assigns value to corresponding variable
            *)
                if [[ -z "$command" ]]; then
                    command="$1"
                elif [[ -z "$description" ]]; then
                    description="$1"
                elif [[ -z "$order" ]]; then
                    order="$1"
                else
                    echo "Error: Unrecognized argument '$1'" >&2
                    return 1
                fi
                ;;
        esac
        shift
    done

    # Ensure command is provided
    if [[ -z "$command" ]]; then
        echo "Error: No command specified" >&2
        return 1
    fi

    # Generate pseudoarray name
    local array_prefix="cmd_${pass}_${component}_${type}"

    # Determine the current index
    index_var="${array_prefix}_ubound"
    index="${!index_var:-0}"

    # Store command details
    eval "${array_prefix}_${index}_command='$command'"
    eval "${array_prefix}_${index}_description='${description:-command $index}'"
    eval "${array_prefix}_${index}_order='${order:-$((index + 1))}'"

    # Store optional parameters if provided
    [[ -n "$domain" ]] && eval "${array_prefix}_${index}_domain='$domain'"
    [[ -n "$user" ]] && eval "${array_prefix}_${index}_user='$user'"
    [[ -n "$pass" ]] && eval "${array_prefix}_${index}_pass='$pass'"
    [[ -n "$willreboot" ]] && eval "${array_prefix}_${index}_willreboot='$willreboot'"
    [[ -n "$requiresinput" ]] && eval "${array_prefix}_${index}_requiresinput='$requiresinput'"

    # Increment the index
    eval "$index_var=$((index + 1))"
}