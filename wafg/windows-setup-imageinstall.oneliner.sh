windows-setup-imageinstall() { printf '\t\t\t<ImageInstall>\n'; while [[ $# -gt 0 ]]; do case "$1" in osimage|dataimage) local type="$1"; shift; windows-setup-imageinstall-$type "$@"; break ;; *) echo "Unknown parameter: $1" >&2; return 1 ;; esac; shift; done; printf '\t\t\t</ImageInstall>\n'; }