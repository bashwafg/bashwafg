helper-cmd-createw10vm() { CMD="qm create $VM_ID"; [[ -z "$VM_MACHINE" && -z "$VM_MACHINE_VER" ]] && CMD+=" --machine q35" || [[ "$VM_MACHINE" == "q35" && -z "$VM_MACHINE_VER" ]] && CMD+=" --machine q35" || [[ "$VM_MACHINE" == "q35" && -n "$VM_MACHINE_VER" ]] && CMD+=" --machine pc-q35-$VM_MACHINE_VER" || { [[ "$VM_MACHINE" =~ 440 || "$VM_MACHINE" == "pc" ]] && [[ -n "$VM_MACHINE_VER" ]] && CMD+=" --machine pc-$VM_MACHINE_VER"; } || { [[ "$VM_MACHINE" != "q35" && ! "$VM_MACHINE" =~ 440 && "$VM_MACHINE" != "pc" ]] && CMD+=" --machine pc-$VM_MACHINE-$VM_MACHINE_VER"; }; [[ "$VM_NO_EFIDISK" != "1" ]] && CMD+=" --efidisk0 $VM_STORAGE_DISK:0$( [[ -n "$VM_EFIDISK_SIZE" ]] && echo ",efitype=$VM_EFIDISK_SIZE" )$( [[ -n "$VM_PRE_ENROLL_KEYS" ]] && echo ",pre-enrolled-keys=$([[ "$VM_PRE_ENROLL_KEYS" == "1" ]] && echo 1 || echo 0)" )"; for var in ACPI AGENT ARCH ARGS AUDIO BALLOON BIOS BOOTORDER BWLIMIT CDROM CORES FREEZE HOOKSCRIPT HOSTPCI HUGEPAGES ISTEMPLATE IVSHMEM KEEPPAGES KVM LOCALTIME MEMORY NAME NAMESERVER NUMA ONBOOT OS_TYPE RNG SCSIHW SEARCHDOMAIN SMBIOS SOCKETS SPICE_ENH SSHKEYS START STARTDATE TAGS TPMSTATE; do [[ -n "${!var}" ]] && CMD+=" --$(echo "$var" | tr '[:upper:]' '[:lower:]' | sed 's/_//g') \"${!var}\""; done; [[ -n "$VM_KEEPPAGES" ]] || [[ -n "$VM_HUGEPAGES" ]] && CMD+=" --keephugepages 1"; echo "$CMD"; }