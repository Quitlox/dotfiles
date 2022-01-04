
###################################
### Keybindings 		        ###
###################################

bindkey '^H' backward-kill-word                         # delete previous word with ctrl+backspace

# Emacs-like
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^U' kill-line                         # Kill until cursor
bindkey '^K' backward-kill-line                                  # Kill line
bindkey '^W' backward-kill-word                         # Kill previous word
bindkey '^Y' yank
# Vi-like
bindkey '^B' vi-backward-blank-word
bindkey '^F' vi-forward-blank-word

# Fix backspace in vi-mode
bindkey -v '^?' backward-delete-char

# default
#bindkey '^L' forward-char
# for zsh-users/zsh-autosuggestions
bindkey '^L' forward-word


# Obvious Special Key Defaults
bindkey '^[[7~' beginning-of-line                       # khome         Home key
bindkey '^[[H' beginning-of-line                        # home          Home key
bindkey '^[[8~' end-of-line                             # kend          End key
bindkey '^[[F' end-of-line                              # end           End key

bindkey '^[[2~' overwrite-mode                          # kich1         Insert key
bindkey '^[[3~' delete-char                             # kdch1         Delete key

bindkey '^[[C'  forward-char                            # curf1 kcuf1   Right key
bindkey '^[[D'  backward-char                           # kcub1         Left key
bindkey '^[[1;5D' backward-word                         #               Ctrl+Left
bindkey '^[[1;5C' forward-word                          #               Ctrl+Right

#bindkey '^[[5~' up-line-or-beginning-search             # kpp           Page up key
#bindkey '^[[6~' history-beginning-search-forward        # knp           Page down key

