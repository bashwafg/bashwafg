helper-create-vm-increment-vmid() { 
  local shift_count=1
  if [[ "$1" =~ ^[0-9]+$ ]]; then 
    VM_ID="$1"
    shift_count=2
  else
    : ${VM_ID:=666}
    VM_ID=$((VM_ID < 100 ? 100 : VM_ID))
  fi
  existing_ids=$(qm list | awk 'NR>1 {print $1}' | sort -n)
  while echo "$existing_ids" | grep -qw "$VM_ID"; do 
    VM_ID=$((VM_ID + 1)) 
  done
  echo "$shift_count"
}