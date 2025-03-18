windows-setup-disk-configuration-createpartition() {
    # Default values
    local extend="true"
    local order="1"
    local size=""
    local type="Primary"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            Extend) shift; extend="$1" ;;
            Order) shift; order="$1" ;;
            Size) shift; size="$1"; extend="" ;;  # If size is set, extend must be empty
            Type) shift; type="$1" ;;
        esac
        shift
    done

    # Generate XML output
    echo -e "\t\t\t\t\t\t<CreatePartition wcm:action=\"add\">"
    echo -e "\t\t\t\t\t\t\t<Order>$order</Order>"
    echo -e "\t\t\t\t\t\t\t<Type>$type</Type>"

    # Include Size element only if size is set
    [[ -n "$size" ]] && echo -e "\t\t\t\t\t\t\t<Size>$size</Size>"

    # Include Extend element only if extend is set
    [[ -n "$extend" ]] && echo -e "\t\t\t\t\t\t\t<Extend>$extend</Extend>"

    echo -e "\t\t\t\t\t\t</CreatePartition>"
}