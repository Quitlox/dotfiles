
############################################################
### Functions		                		 ###
############################################################

open () {
    nohup xdg-open $1 > /dev/null &
}

bw-login () {
    export BW_SESSION=$(bw unlock --raw)
}

# Reload: Reloads the zsh config of the current session
reload () {
		exec "${SHELL}" "$@"
}

# Escape: Escape a string (e.g. path) 
escape() {
		# Uber useful when you need to translate weird as fuck path into single-argument string.
		local escape_string_input
		echo -n "String to escape: "
		read escape_string_input
		printf '%q\n' "$escape_string_input"
}

# Change working directory to ChezMoi source directory
chm() {
    cd $(chezmoi source-path)
}

# Reverse-bindkey-lookup
reverse-bindkey-lookup() { print ${(k)terminfo[(Re)$(print -b $1)]} }


