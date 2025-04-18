# Clean up PATH by removing ALL /mnt/c/ entries
IFS=':' read -A path_parts <<< "$PATH"
NEW_PATH=""
for part in "${path_parts[@]}"; do
  if [[ "$part" != */mnt/c/* ]]; then
    if [[ -z "$NEW_PATH" ]]; then
      NEW_PATH="$part"
    else
      NEW_PATH="$NEW_PATH:$part"
    fi
  fi
done

# Update PATH without any /mnt/c/ entries
export PATH="$NEW_PATH"

# Create aliases for Windows executables with direct paths
alias explorer.exe="/mnt/c/Windows/explorer.exe"
alias sioyek.exe="/mnt/c/Users/witloxkhd/Applications/sioyek/sioyek.exe"
