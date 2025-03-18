repack-iso() { 
	local original_args=("$@")
	local arch="${arch:-amd64}"
    local adddriver=("${adddriver[@]}") 
    local addfile=("${addfile[@]}") 
    local addvirtio_flag="${addvirtio_flag:-0}"
    local autoboot_flag="${autoboot_flag:-0}"
    local debug_flag="${debug_flag:-0}"
    local injectbootfile=("${injectbootfile[@]}") 
    local injectbootreg=("${injectbootreg[@]}") 
    local injectinstallfile=("${injectinstallfile[@]}") 
    local injectinstallreg=("${injectinstallreg[@]}")  
    local sourceiso destinationiso
    local template="${template:-}"
    local unattend="${unattend:-}"
    local wafg_flag="${wafg_flag:-0}"
    local wipeworkdir_flag="${wipe_flag:-0}"

    # Determine source ISO path
    helper-repack-iso-get-sourceiso "$@"; [[ $? -ne 0 ]] && return 1; shift $([[ "$2" == *"username"* ]] && echo 2 || echo 1);

    # Determine destination ISO path
    helper-repack-iso-get-destinationiso "$@"; [[ $? -ne 0 ]] && return 1; shift 1;
	workdir="${workdir:-$(dirname "$destinationiso")/repack-iso-workdir-$(basename "$destinationiso" .iso)}"

	echo "source iso path: $sourceiso destinationiso path $destinationiso workdir $workdir"
    # Parse additional arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            workdir) shift; [[ -n "$1" ]] && workdir="$1"; shift ;;
            wipeworkdir|autowipe|autoboot|wafg|addvirtio|debug) eval "${1}_flag=1"; shift ;;
            template|unattend) shift; [[ -n "$1" ]] && eval "$1=\"\$2\""; shift ;;
            addfile|adddriver|injectbootfile|injectinstallfile|injectbootreg|injectinstallreg) 
                [[ -n "$2" ]] && eval "$1+=(\"\$2\")"; shift 2 ;;
            *) break ;;  # ✅ Stop argument parsing when encountering unknown argument
        esac
    done
    
    
    # Debug mode: Print internal state
    [[ $debug_flag -eq 1 ]] && helper-repack-iso-internal-status ; echo "📜 Remainder Command-Line Arguments (\$@):"; for arg in "$@"; do printf '   "%s"\n' "$arg"; done

    # Wipe workdir if requested
    [[ $wipeworkdir_flag -eq 1 ]] && helper-repack-iso-wipeworkdir "$workdir"

    # Create workdir and necessary subdirectories
    helper-repack-iso-create-workdir "$workdir"

    # Unpack the source ISO if needed
    helper-repack-iso-unpack-sourceiso "$sourceiso" "$workdir"

    # Prepare VirtIO drivers if requested
    [[ $addvirtio_flag -eq 1 ]] && helper-repack-iso-prepare-virtio "$workdir/tmp/virtio"; helper-repack-iso-copy-virtio "$workdir/tmp/virtio" "$workdir/iso-master/\$WinPeDriver\$" "$isoversion" "$arch"

    # Copy files and drivers to iso-master
    helper-repack-iso-copy "addfile" "$workdir/iso-master"
    helper-repack-iso-copy "adddriver" "$workdir/iso-master/'$WinPeDriver$'"

    # Inject files and registry modifications into boot.wim and install.wim
    helper-repack-iso-inject-files-into-wim "injectbootfile" "$workdir/iso-master/sources/boot.wim"
    helper-repack-iso-inject-files-into-wim "injectinstallfile" "$workdir/iso-master/sources/install.wim"
    helper-repack-iso-inject-reg-into-wim "injectbootreg" "$workdir/iso-master/sources/boot.wim" "$workdir/wimmount"
    helper-repack-iso-inject-reg-into-wim "injectinstallreg" "$workdir/iso-master/sources/install.wim" "$workdir/wimmount"
	
	local VM_REPACK_ARCH=$([[ "$arch" == "amd64" ]] || echo "$arch"); [[ -n "$VM_REPACK_ARCH" ]] && set -- "$VM_REPACK_ARCH" "$@" || set -- "$@"
	[[ $wafg_flag -eq 1 ]] && compgen -v | grep -q '^VM_' && VM_REPACK_WAFG="$(printf '%s ' "$@")"
	[[ $wafg_flag -eq 1 ]] && windows-shell-setup-print-commands | tee "$workdir/iso-master/info.txt"
	echo "Original arguments: repack-iso ${original_args[@]}" > "$workdir/iso-master/info.txt"
	[[ $wafg_flag -eq 1 ]] && echo "Repack command: $VM_REPACK_COMMAND" >> "$workdir/iso-master/info.txt"
	declare -F helper-create-win10-vm-debug >/dev/null && compgen -v | grep -q '^VM_' && helper-create-win10-vm-debug >> "$workdir/iso-master/info.txt"
	[[ $wafg_flag -eq 1 ]] && echo "Running wafg-auto verbose $VM_REPACK_WAFG" >> "$workdir/iso-master/info.txt"
	[[ $wafg_flag -eq 1 ]] && eval "wafg-auto dryrun verbose $VM_REPACK_WAFG" >> "$workdir/iso-master/info.txt"

    # Run wafg-auto if wafg_flag is set
    [[ $wafg_flag -eq 1 ]] && unattend="$workdir/unattend/autounattend-$(date +"%Y%m%d-%H%M").xml" && echo "Running wafg-auto $VM_REPACK_WAFG > \"$unattend\"" ; eval "wafg-auto $VM_REPACK_WAFG" | tee "$unattend" -a "$workdir/iso-master/info.txt"; helper-repack-iso-copy-unattend "$workdir/iso-master" "${unattend:-$workdir/unattend}"

    # Create final bootable ISO
	echo "Running helper-repack-iso-create-iso-with-xorriso \"$workdir/iso-master\" \"$destinationiso\""
    helper-repack-iso-create-iso-with-xorriso "$workdir/iso-master" "$destinationiso"
}