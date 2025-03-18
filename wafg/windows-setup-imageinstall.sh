windows-setup-imageinstall() {
    # Start ImageInstall XML block
    printf '\t\t\t<ImageInstall>\n'

    # Process arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            osimage|dataimage)
                local type="$1"
                shift
                windows-setup-imageinstall-"$type" "$@"
                break
                ;;
            *)
                echo "Unknown parameter: $1" >&2
                return 1
                ;;
        esac
        shift
    done

    # End ImageInstall XML block
    printf '\t\t\t</ImageInstall>\n'
}