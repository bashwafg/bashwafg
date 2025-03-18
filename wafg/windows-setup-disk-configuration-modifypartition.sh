windows-setup-disk-configuration-modifypartition() {
    # Initialize variables
    local active="" extend="" format="" label="" letter="" order=1 partitionid="" typeid=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            Active) shift; active="$1" ;;
            Extend) shift; extend="$1" ;;
            Format) shift; format="$1" ;;
            Label) shift; label="$1" ;;
            Letter) shift; letter="$1" ;;
            Order) shift; order="$1" ;;
            PartitionID) shift; partitionid="$1" ;;
            TypeID) shift; typeid="$1" ;;
        esac
        shift
    done

    # Generate XML output using multiple echo commands
    echo -e "\t\t\t\t\t\t<ModifyPartition wcm:action=\"add\">"
    echo -e "\t\t\t\t\t\t\t<Order>$order</Order>"
    [[ -n "$active" ]]      && echo -e "\t\t\t\t\t\t\t<Active>$active</Active>"
    [[ -n "$partitionid" ]] && echo -e "\t\t\t\t\t\t\t<PartitionID>$partitionid</PartitionID>"
    [[ -n "$label" ]]       && echo -e "\t\t\t\t\t\t\t<Label>$label</Label>"
    [[ -n "$letter" ]]      && echo -e "\t\t\t\t\t\t\t<Letter>$letter</Letter>"
    [[ -n "$format" ]]      && echo -e "\t\t\t\t\t\t\t<Format>$format</Format>"
    [[ -n "$typeid" ]]      && echo -e "\t\t\t\t\t\t\t<TypeID>$typeid</TypeID>"
    [[ -n "$extend" ]]      && echo -e "\t\t\t\t\t\t\t<Extend>$extend</Extend>"
    echo -e "\t\t\t\t\t\t</ModifyPartition>"
}