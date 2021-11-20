
############################################################
### Exports                                              ###
############################################################

# Editors
export EDITOR=/usr/bin/vim
export VISUAL=/usr/bin/vim

# Manpager
#if command -v bat > /dev/null 2>&1; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
#fi
