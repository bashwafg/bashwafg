helper-repack-iso-unmount() { find "$1" -type d -exec mountpoint -q {} \; -exec umount {} \; 2>/dev/null; }