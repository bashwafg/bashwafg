windows-shell-setup-add-logoncommands(){ logoncommandarr_ubound=${logoncommandarr_ubound:-0}; local index=$logoncommandarr_ubound; eval "logoncommandarr_${index}_commandline='$1'"; eval "logoncommandarr_${index}_description='${2:-command $index}'"; eval "logoncommandarr_${index}_requiresinput='${3:-false}'"; [[ -n "$4" ]] && eval "logoncommandarr_${index}_order='$4'"; logoncommandarr_ubound=$((index + 1)); }