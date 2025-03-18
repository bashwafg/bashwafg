windows-setup-remainder() {
    # Initialize empty variables
    local PagePath="" PageSize="" Restart="" UpgradeData="" UseConfigurationSet=""
    local LogPath="" EnableNetwork="" EnableFirewall="" DynamicUpdate=""
    local HorizontalResolution="" VerticalResolution="" ColorDepth="" RefreshRate=""

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            PagePath|PageSize|Restart|UpgradeData|UseConfigurationSet|LogPath|EnableNetwork|EnableFirewall|DynamicUpdate|HorizontalResolution|VerticalResolution|ColorDepth|RefreshRate)
                eval "$1=\$2"; shift 2 ;;
            *)
                echo "Unknown parameter: $1" >&2
                return 1
                ;;
        esac
    done

    # Output Display settings if any are set
    if [[ -n "$HorizontalResolution" || -n "$VerticalResolution" || -n "$ColorDepth" || -n "$RefreshRate" ]]; then
        printf '\t\t\t<Display>\n'
        [[ -n "$HorizontalResolution" ]] && printf '\t\t\t\t<HorizontalResolution>%s</HorizontalResolution>\n' "$HorizontalResolution"
        [[ -n "$VerticalResolution" ]] && printf '\t\t\t\t<VerticalResolution>%s</VerticalResolution>\n' "$VerticalResolution"
        [[ -n "$ColorDepth" ]] && printf '\t\t\t\t<ColorDepth>%s</ColorDepth>\n' "$ColorDepth"
        [[ -n "$RefreshRate" ]] && printf '\t\t\t\t<RefreshRate>%s</RefreshRate>\n' "$RefreshRate"
        printf '\t\t\t</Display>\n'
    fi

    # Output DynamicUpdate section if set
    if [[ -n "$DynamicUpdate" ]]; then
        printf '\t\t\t<DynamicUpdate>\n'
        printf '\t\t\t\t<Enable>%s</Enable>\n' "$DynamicUpdate"
        printf '\t\t\t\t<WillShowUI>Never</WillShowUI>\n'
        printf '\t\t\t</DynamicUpdate>\n'
    fi

    # Output EnableFirewall if set
    [[ -n "$EnableFirewall" ]] && printf '\t\t\t<EnableFirewall>%s</EnableFirewall>\n' "$EnableFirewall"

    # Output EnableNetwork if set
    [[ -n "$EnableNetwork" ]] && printf '\t\t\t<EnableNetwork>%s</EnableNetwork>\n' "$EnableNetwork"

    # Output LogPath if set
    [[ -n "$LogPath" ]] && printf '\t\t\t<LogPath>%s</LogPath>\n' "$LogPath"

    # Output PageFile section if either PagePath or PageSize is set
    if [[ -n "$PagePath" || -n "$PageSize" ]]; then
        printf '\t\t\t<PageFile>\n'
        [[ -n "$PagePath" ]] && printf '\t\t\t\t<Path>%s</Path>\n' "$PagePath"
        [[ -n "$PageSize" ]] && printf '\t\t\t\t<Size>%s</Size>\n' "$PageSize"
        printf '\t\t\t</PageFile>\n'
    fi

    # Output Restart if set
    [[ -n "$Restart" ]] && printf '\t\t\t<Restart>%s</Restart>\n' "$Restart"

    # Output UpgradeData section if set
    if [[ -n "$UpgradeData" ]]; then
        printf '\t\t\t<UpgradeData>\n'
        printf '\t\t\t\t<Upgrade>%s</Upgrade>\n' "$UpgradeData"
        printf '\t\t\t\t<WillShowUI>Never</WillShowUI>\n'
        printf '\t\t\t</UpgradeData>\n'
    fi
}