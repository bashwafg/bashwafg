cmd_unattend_innerxml() {
    local inner_tag=""
    local array_prefix=""
    local index=""
    local needs_wcm_add="false"

    # Command details (defaults)
    local command=""
    local description=""
    local order=""
    local domain=""
    local user=""
    local pass=""
    local willreboot=""
    local requiresinput=""

    # Detect if we are using a pseudoarray
    if [[ $# -eq 4 && -n "$(eval echo "\${cmd_${2}_${3}_command+set}")" ]]; then
        inner_tag="$1"
        array_prefix="$2"
        index="$3"
        needs_wcm_add="$4"

        # Load values from the pseudoarray
        eval "command=\${cmd_${array_prefix}_${index}_command}"
        eval "description=\${cmd_${array_prefix}_${index}_description}"
        eval "order=\${cmd_${array_prefix}_${index}_order}"
        eval "domain=\${cmd_${array_prefix}_${index}_domain}"
        eval "user=\${cmd_${array_prefix}_${index}_user}"
        eval "pass=\${cmd_${array_prefix}_${index}_pass}"
        eval "willreboot=\${cmd_${array_prefix}_${index}_willreboot}"
        eval "requiresinput=\${cmd_${array_prefix}_${index}_requiresinput}"

    else
        # Otherwise, parse inline arguments
        inner_tag="$1"
        shift

        while [[ $# -gt 0 ]]; do
            case "$1" in
                command) shift; command="$1" ;;
                description) shift; description="$1" ;;
                order) shift; order="$1" ;;
                domain) shift; domain="$1" ;;
                user) shift; user="$1" ;;
                pass) shift; pass="$1" ;;
                willreboot) shift; willreboot="$1" ;;
                requiresinput) shift; requiresinput="$1" ;;
                wcm_add) needs_wcm_add="true" ;;  # Optional flag for wcm:action="add"
                *)
                    echo "Error: Unrecognized parameter '$1'" >&2
                    return 1
                    ;;
            esac
            shift
        done
    fi

    # Ensure the command is provided
    if [[ -z "$command" ]]; then
        echo "Error: No command specified" >&2
        return 1
    fi

    # Begin inner XML tag
    echo -ne "\t\t<$inner_tag"

    # Add `wcm:action="add"` if required
    [[ "$needs_wcm_add" == "true" ]] && echo -n ' wcm:action="add"'

    echo ">"

    # Order (always required)
    [[ -n "$order" ]] && echo -e "\t\t\t<Order>$order</Order>"

    # Description (optional)
    [[ -n "$description" ]] && echo -e "\t\t\t<Description>$description</Description>"

    # Determine if we use `Path` or `CommandLine`
    case "$inner_tag" in
        SynchronousCommand|AsynchronousCommand)
            echo -e "\t\t\t<CommandLine>$command</CommandLine>"
            ;;
        RunSynchronousCommand|RunAsynchronousCommand)
            echo -e "\t\t\t<Path>$command</Path>"
            ;;
    esac

    # RequiresUserInput (only for shell commands)
    [[ -n "$requiresinput" ]] && echo -e "\t\t\t<RequiresUserInput>$requiresinput</RequiresUserInput>"

    # Credentials block (if provided)
    if [[ -n "$domain" || -n "$user" || -n "$pass" ]]; then
        echo -e "\t\t\t<Credentials>"
        [[ -n "$domain" ]] && echo -e "\t\t\t\t<Domain>$domain</Domain>"
        [[ -n "$user" ]] && echo -e "\t\t\t\t<UserName>$user</UserName>"
        [[ -n "$pass" ]] && echo -e "\t\t\t\t<Password>$pass</Password>"
        echo -e "\t\t\t</Credentials>"
    fi

    # WillReboot (only applies to `Microsoft-Windows-Deployment RunSynchronousCommand`)
    [[ -n "$willreboot" ]] && echo -e "\t\t\t<WillReboot>$willreboot</WillReboot>"

    # End inner XML tag
    echo -e "\t\t</$inner_tag>"
}