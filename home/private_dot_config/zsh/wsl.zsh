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
typeset -A _wsl_aliases=(
  [explorer.exe]="/mnt/c/Windows/explorer.exe"
  [sioyek.exe]="/mnt/c/Users/witloxkhd/AppData/Local/Microsoft/WinGet/Packages/ahrm.sioyek_Microsoft.Winget.Source_8wekyb3d8bbwe/sioyek-release-windows/sioyek.exe"
  [win32yank.exe]="/mnt/c/Program Files/Neovim/bin/win32yank.exe"
)

# ------------------------------------------------------------------------------
# Set aliases, print warnings for broken links
# ------------------------------------------------------------------------------
_wsl_warnings=()
for _name _target in "${(@kv)_wsl_aliases}"; do
  if [[ -x "$_target" ]]; then
    alias "$_name=$_target"
  else
    _wsl_warnings+=("[warn] WSL alias '$_name' target not found: $_target")
  fi
done
unset _name _target _wsl_aliases

# Defer warnings until after the prompt is drawn (once)
if (( ${#_wsl_warnings} )); then
  function _wsl_print_warnings() {
    for _msg in "${_wsl_warnings[@]}"; do
      print -u2 "$_msg"
    done
    print -u2 "       Edit \${XDG_CONFIG_HOME:-~/.config}/zsh/wsl.zsh to fix."
    unset _wsl_warnings
    precmd_functions=(${precmd_functions:#_wsl_print_warnings})
    unfunction _wsl_print_warnings
  }
  precmd_functions+=(_wsl_print_warnings)
else
  unset _wsl_warnings
fi
