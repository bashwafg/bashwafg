get_iso_path() { awk -v s="$1" '$1 == "dir:" && $2 == s {f=1; next} f && $1 == "path" {print $2 "/template/iso"; exit} f && /^dir:|lvmthin:/ {exit}' /etc/pve/storage.cfg; }