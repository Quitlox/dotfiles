
############################################################
### Aliases                                              ###
############################################################

# Enable vim server by default
# Usefull for synctex + live updating color scheme
if vim --version | grep -q '+clientserver'; then
	alias vim='vim --servername vim'
fi

# Git (override davidde/git aliasses, fzf)
alias gs='git_status_short'
alias gfa='git add $(git ls-files --modified --others --exclude-standard | fzf -m)'

# Needed for kitty terminal
alias ssh='kitty +kitten ssh'

alias cp='cp -iv' 		# cp: Confirm + Verbose
alias df='df -h' 		# Human-readable sizes
alias free='free -m' 		# Show sizes in MB
alias mv='mv -iv'
alias rm='rm -Iv'
alias rmdir='rmdir -v'
alias ln='ln -v'
alias chmod="chmod -c"
alias chown="chown -c"
alias mkdir="mkdir -v"

#if command -v exa > /dev/null 2>&1; then
	alias l="EXA_ICON_SPACING=2 eza --all --icons --long --group-directories-first"
	alias ls="EXA_ICON_SPACING=2 eza --long --group-directories-first"
#fi

#if command -v zoxide > /dev/null 2>&1; then
	alias cd="z"
#fi

# CHEZMOI
bw-login() {
	emulate -L sh;
	if ! \bw --nointeraction login --check; then
		export BW_SESSION=$(\bw login --raw)
	elif ! \bw --nointeraction unlock --check; then
		export BW_SESSION=$(\bw unlock --raw)
	fi
}

# XDG_BASE_DIR
alias wget="wget --hsts-file=\"$XDG_CACHE_HOME/wget-hsts\""


########################################
### Colorize                         ###
########################################

if command -v colordiff > /dev/null 2>&1; then
	alias diff="colordiff -Nuar"
else
	alias diff="diff -Nuar"
fi

alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias ip='ip -color=auto'

