helper-create-win10-vm-debug() {
  echo "=== DEBUG: All Set VM_* Variables ==="

  # Arrays to store different types of variables
  declare -A normal_vars
  declare -A array_vars
  declare -A array_lengths

  # Iterate over all environment variables
  for var in $(compgen -v | grep '^VM_'); do
    # Get the variable value using indirect reference
    value="${!var}"

    # Check if the variable is an array
    if [[ "$(declare -p $var 2>/dev/null)" =~ "declare -a" ]]; then
      eval "filtered_array=(\"\${$var[@]}\")"
      filtered_array=("${filtered_array[@]/()/}")  # Remove empty "()" elements
      array_vars[$var]="${filtered_array[*]}"
      array_lengths[$var]=${#filtered_array[@]}
    else
      # Store normal variables
      normal_vars[$var]="$value"
    fi
  done

  # Print normal variables first
  for var in "${!normal_vars[@]}"; do
    printf '%s="%s"\n' "$var" "${normal_vars[$var]}"
  done
  echo ""

  # Print array variables
  for var in "${!array_vars[@]}"; do
    printf '%s=(%s)\n' "$var" "${array_vars[$var]}"
  done
  echo ""

  # Print array lengths
  for var in "${!array_lengths[@]}"; do
    printf '%s length: %d\n' "$var" "${array_lengths[$var]}"
  done
  echo ""
}