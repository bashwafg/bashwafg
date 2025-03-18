create-win-vm() {
  local VM_ORIGINAL_COMMAND=("$@")
  # Determine VM_ID and VM_NAME
  [[ "$1" =~ ^[0-9]+$ ]] && VM_ID="$1" && shift && VM_NAME="$1" && shift || { VM_NAME="$1"; shift; helper-create-vm-increment-vmid; }
  
  # Declare all supported variables as local while preserving their values if already set
  local VM_AGENT="${VM_AGENT-}"
  local VM_ARGS="${VM_ARGS-}"
  local VM_BALLOON="${VM_BALLOON-}"
  local VM_BIOS="${VM_BIOS-}"
  local VM_BOOTORDER="${VM_BOOTORDER-}"
  local VM_BWLIMIT="${VM_BWLIMIT-}"
  local VM_CDROM="${VM_CDROM-}"
  local VM_CLOUDINIT="${VM_CLOUDINIT-}"
  local VM_CORES="${VM_CORES-}"
  local VM_DESCRIPTION="${VM_DESCRIPTION-}"
  local VM_DISK_SIZE="${VM_DISK_SIZE-}"
  local VM_EFIDISK_SIZE="${VM_EFIDISK_SIZE-}"
  local VM_FREEZE="${VM_FREEZE-}"
  local VM_HOOKSCRIPT="${VM_HOOKSCRIPT-}"
  local VM_HOSTPCI="${VM_HOSTPCI-}"
  local VM_HUGEPAGES="${VM_HUGEPAGES-}"
  local VM_INSTALLER_FILENAME="${VM_INSTALLER_FILENAME-}"
  local VM_IOMMU="${VM_IOMMU-}"
  local VM_ISTEMPLATE="${VM_ISTEMPLATE-}"
  local VM_IVSHMEM="${VM_IVSHMEM-}"
  local VM_KVM="${VM_KVM-}"
  local VM_LOCALTIME="${VM_LOCALTIME-}"
  local VM_MACHINE="${VM_MACHINE-}"
  local VM_MACHINE_VER="${VM_MACHINE_VER-}"
  local VM_MAC_ADDRESS="${VM_MAC_ADDRESS-}"
  local VM_MEMORY="${VM_MEMORY-}"
  local VM_NAMESERVER="${VM_NAMESERVER-}"
  local VM_NETHW="${VM_NETHW-}"
  local VM_NETWORK_BRIDGE="${VM_NETWORK_BRIDGE-}"
  local VM_NET_STATUS="${VM_NET_STATUS-}"
  local VM_NET_TAG="${VM_NET_TAG-}"
  local VM_NO_EFIDISK="${VM_NO_EFIDISK-}"
  local VM_NO_REPACK="${VM_NO_REPACK-}"
  local VM_NUMA="${VM_NUMA-}"
  local VM_ONBOOT="${VM_ONBOOT-}"
  local VM_OS_TYPE="${VM_OS_TYPE-}"
  local VM_PRE_ENROLL_KEYS="${VM_PRE_ENROLL_KEYS-}"
  local VM_REPACK="${VM_REPACK-}"
  local VM_REPACK_WAFG="empty"
  local VM_RNG_MAX="${VM_RNG_MAX-}"
  local VM_RNG_PERIOD="${VM_RNG_PERIOD-}"
  local VM_SCSIHW="${VM_SCSIHW-}"
  local VM_SEARCHDOMAIN="${VM_SEARCHDOMAIN-}"
  local VM_SMBIOS="${VM_SMBIOS-}"
  local VM_SOCKETS="${VM_SOCKETS-}"
  local VM_SPICE="${VM_SPICE-}"
  local VM_SPICEFOLDER="${VM_SPICEFOLDER-}"
  local VM_SPICESTREAM="${VM_SPICESTREAM-}"
  local VM_SSHKEYS="${VM_SSHKEYS-}"
  local VM_START="${VM_START-}"
  local VM_STORAGE_DISK="${VM_STORAGE_DISK-}"
  local VM_STORAGE_ISO="${VM_STORAGE_ISO-}"
  local VM_TAGS="${VM_TAGS-}"
  local VM_TEMPLATE="${VM_TEMPLATE-defaults}"
  local VM_TEMPLATE_FILENAME="${VM_TEMPLATE_FILENAME-}"
  local VM_VGA="${VM_VGA-}"
  local VM_VIRTIO_FILENAME="${VM_VIRTIO_FILENAME-}"
  local VM_WAFG="${VM_WAFG-}"
  local VM_WINDOWS_SETTINGS="${VM_WINDOWS_SETTINGS-}"
  # handle username overrride
  
  # Declare all arrays as local while preserving their values if already set
  local -a VM_AUDIO=("${VM_AUDIO[@]}")
  local -a VM_IDE=("${VM_IDE[@]}")
  local -a VM_NET=("${VM_NET[@]}")
  local -a VM_NVME=("${VM_NVME[@]}")
  local -a VM_PARALLEL=("${VM_PARALLEL[@]}")
  local -a VM_PCI=("${VM_PCI[@]}")
  local -a VM_RNG=("${VM_RNG[@]}")
  local -a VM_SATA=("${VM_SATA[@]}")
  local -a VM_SCSI=("${VM_SCSI[@]}")
  local -a VM_SERIAL=("${VM_SERIAL[@]}")
  local -a VM_USB=("${VM_USB[@]}")
  
  # Parse provided arguments
  helper-create-vm-parse-argument "$@"
  
  # Set default values
  helper-create-vm-template "$VM_TEMPLATE"
  windows-settings-commands ${VM_WINDOWS_SETTINGS}

  # Repack ISO unless VM_NO_REPACK is set
  if [[ -z "$VM_NO_REPACK" ]]; then
    local VM_INSTALLER_FILENAME="${VM_TEMPLATE_FILENAME/.iso/.unattended.latest.iso}"
	echo repack-iso "$VM_TEMPLATE_FILENAME" "$VM_INSTALLER_FILENAME" $VM_REPACK ${VM_WAFG:+wafg} $VM_WAFG
	local VM_REPACK_COMMAND="repack-iso \"$VM_TEMPLATE_FILENAME\" \"$VM_INSTALLER_FILENAME\" $VM_REPACK ${VM_WAFG:+wafg} $VM_WAFG"
    repack-iso "$VM_TEMPLATE_FILENAME" "$VM_INSTALLER_FILENAME" $VM_REPACK ${VM_WAFG:+wafg} $VM_WAFG 
  fi

  { installer_file="${VM_INSTALLER_FILENAME:-$VM_TEMPLATE_FILENAME}"; installer_storage=$(find_iso_storage_for_file "$installer_file"); [[ -n "$installer_storage" ]] && VM_CDROM="$installer_storage:iso/$installer_file,media=cdrom"; }
  [[ -n "$VM_VIRTIO_FILENAME" ]] && { virtio_storage=$(find_iso_storage_for_file "$VM_VIRTIO_FILENAME"); [[ -n "$virtio_storage" ]] && VM_IDE+=("$virtio_storage:iso/$VM_VIRTIO_FILENAME,media=cdrom"); }

  # Generate the base command using the helper function
  CMD=$(helper-cmd-createw10vm)
    
  # Append dynamically generated device arguments
  helper-create-vm-array-cmd

  # Debug: Print all variables before execution
  helper-create-win10-vm-debug
  
  # Execute the command
  echo command is "$CMD"
  #VM_DESCRIPTION=$'${VM_DESCRIPTION:-}\n\nOriginal Command:\n'"${VM_ORIGINAL_COMMAND[@]}"$'\n\nRepack Command:\n'"${VM_REPACK_COMMAND:-Not Set}${VM_REPACK_WAFG:-Not Set}"$'\n\nWAFG Settings:\n'"${VM_WAFG:-Not Set}"$'\n\nGenerated Command:\n'"$CMD"$'\n\nDebug Information:\n'"$(helper-create-win10-vm-debug)"
  [[ -n "$VM_DESCRIPTION" ]]       && CMD+=" --description \"$VM_DESCRIPTION\""
  eval "$CMD"
}