#!/bin/bash

# EXIT
set -e
function cleanup {
    bwarning "This script has been brutally murdered"
    exit
}
trap cleanup INT QUIT TERM

declare -A colors;
colors=(\
    ['black']='\033[0;30m'\
    ['red']='\033[0;31m'\
    ['green']='\033[0;32m'\
    ['yellow']='\033[0;33m'\
    ['blue']='\033[0;34m'\
    ['magenta']='\033[0;35m'\
    ['cyan']='\033[0;36m'\
    ['white']='\033[0;37m'\

    ['bbloack']='\033[1;30m'\
    ['bred']='\033[1;31m'\
    ['bgreen']='\033[1;32m'\
    ['byellow']='\033[1;33m'\
    ['bblue']='\033[1;34m'\
    ['bmagenta']='\033[1;35m'\
    ['bcyan']='\033[1;36m'\
    ['bwhite']='\033[1;37m'\
);

# Dependencies
cecho () {
    local defaultMSG="No message passed.";
    local defaultColor="black";
    local defaultNewLine=true;

    while [[ $# -gt 1 ]];
    do
    key="$1";

    case $key in
        -c|--color)
            color="$2";
            shift;
        ;;
        -n|--noline)
            newLine=false;
        ;;
        *)
            # unknown option
        ;;
    esac
    shift;
    done

    message=${1:-$defaultMSG};   # Defaults to default message.
    color=${color:-$defaultColor};   # Defaults to default color, if not specified.
    newLine=${newLine:-$defaultNewLine};

    echo -en "${colors[$color]}";
    echo -en "$message";
    if [ "$newLine" = true ] ; then
        echo;
    fi
    tput sgr0; #  Reset text attributes to normal without clearing screen.

    return;
}

function warning () {
    cecho -c 'yellow' "=> $@";
}
function bwarning () {
    cecho -c 'byellow' "=> ⚠️  $@";
}

function error () {
    cecho -c 'red' "=> $@";
}
function berror () {
    cecho -c 'bred' "=> ⚡ $@";
}

function information () {
    cecho -c 'blue' "=> $@";
}
function binformation () {
    cecho -c 'bblue' "=> ℹ️  $@";
}
function success () {
    cecho -c 'green' "=> $@";
}
function bsuccess () {
    cecho -c 'bgreen' "=> ✅ $@";
}
function log () {
    cecho -c 'white' "=> $@";
}

function install () {
    command=$1
    package=$2

    warning "Installing $package..."
    if eval "$command $package"; then
        success "Installed $package! Continuing..."
    else
        berror "Failed to install $package! Aborting."
        exit -1
    fi
}

function install_apt () {
    package=$1
    install "sudo apt install -y" $package
}
function install_pacman () {
    package=$1
    install "sudo pacman -S --needed" $package
}

# VARIABLES
BW_BIN="$HOME/.local/bin/bw"

# [BOOTSTRAPPING - DIRECTORIES]
[[ ! -e "$HOME/.local" ]] && mkdir "$HOME/.local" && information "Created folder ~/.local"
[[ ! -e "$HOME/.local/src" ]] && mkdir "$HOME/.local/src" && information "Created folder ~/.local/src"
[[ ! -e "$HOME/.local/bin" ]] && mkdir "$HOME/.local/bin" && information "Created folder ~/.local/bin"

# [BOOTSTRAPPING - PATH]
if [[ ! ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
	information "Adding ~/.local/bin to \$PATH"
	export PATH=$PATH:$HOME/.local/bin
fi

# [BOOTSTRAPPING - 7zip]
if ! command -v "unzip" &> /dev/null &&! command -v "7z" &> /dev/null && ! command -v "p7zip" &> /dev/null; then
    # bwarning "Neither unzip or p7zip is installed!"
    if command -v "pacman" &> /dev/null; then
        install_pacman p7zip
    elif command -v "apt" &> /dev/null; then
        install_apt p7zip-full
    else
        berror "No package manager found. Aborting."
	    exit -1
    fi
fi

# [BOOTSTRAPPING - age]
if ! command -v "age" &> /dev/null; then
    if command -v "pacman" &> /dev/null; then
        install_pacman age
    elif command -v "apt" &> /dev/null; then
        install_apt age
    else
        berror "No package manager found. Aborting."
	    exit -1
    fi
fi

# [BOOTSTRAPPING - yay]
if [[ $(uname -r) == *"MANJARO"* ]] || [[ $(uname -r) == *"arch"* ]]; then
    if ! command -v "yay" &> /dev/null; then
	    binformation "yay not installed!"
	    sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git ~/.local/src/yay && (cd ~/.local/src/yay && makepkg -si)
    fi
fi

# [BOOTSTRAPPING - BITWARDEN]
if ! command -v bw &> /dev/null
then
	# [BOOTSTRAPPING - BITWARDEN]
	binformation "Bitwarden not installed, bootstrapping Bitwarden..."

	# [BOOTSTRAPPING - BITWARDEN] Get tag of latest release
	TAG=$(curl -L --silent "https://api.github.com/repos/bitwarden/cli/releases/latest" \
		| grep '"tag_name":' \
		| sed -E 's/.*"([^"]+)".*/\1/')
	BW_SRC="$HOME/.local/src/bitwardencli/bw-${TAG}"
	if [[ -z "$TAG" ]]; then
	    berror "Something went wrong while fetching the Bitwarden release"
	    exit
	fi
	information "Found release: ${TAG}"

	# EXPLANATION
	#curl \
	#       # Follow redirects \
	#	-L \
	#	# Get Response in JSON format \
	#	-H "Accept: application/vnd.github.v3+json" \
	#	# Do not print download progress \
	#	--silent "https://api.github.com/repos/bitwarden/cli/releases/tags/v1.19.1" \
	#		# For each Release Asset, print grep on the "name" field \
	#		# -B 3 includes the "id" field as well \
	#		| grep -B 3 '"name"' \
	#		# Filter on the linux release \
	#		| grep -B 3 'linux.*.zip' \
	#		# Grep the corresponding "id" field \
	#		| awk '/"id"/ { print $2 }' \
	#		# Remove a comma \
	#		| sed 's/,//'

	# [BITWARDEN] Get the id of the 'linux.*.zip' Asset
	ASSET_ID=$(curl -L -H "Accept: application/vnd.github.v3+json" \
		"https://api.github.com/repos/bitwarden/cli/releases/tags/v1.19.1" \
			| grep -B 3 '"name"' \
			| grep -B 3 'linux.*.zip' \
			| awk '/"id"/ { print $2 }' \
			| sed 's/,//')
	if [[ -z "$ASSET_ID" ]]; then
	    berror "Something went wrong while fetching the Bitwarden asset"
	    exit
	fi
	information "Found asset: ${ASSET_ID}"


	# [BOOTSTRAPPING - BITWARDEN] Download latest release
	if [[ ! -e "$BW_ZIP.zip" ]]; then
		# No, so download the latest asset

		# Create directory if non-existant
		[[ ! -e "$HOME/.local/src/bitwardencli" ]] && mkdir "$HOME/.local/src/bitwardencli" && information "Created folder ~/.local/src/bitwardencli"

		# Download...
		information "Downloading..."
		curl -L -H "Accept: application/octet-stream" \
			"https://api.github.com/repos/bitwarden/cli/releases/assets/48085900" \
			--output "$BW_SRC.zip"
	else
		warning "Latest release already downloaded!"
	fi

	# [BOOTSTRAPPING - BITWARDEN] Extract the binary
	if [[ ! -e "$BW_SRC" ]]; then
		information "Extracting binary $BW_SRC.zip"
		if command -v "unzip" &> /dev/null; then
		    unzip "$BW_SRC.zip" -d "$BW_SRC"
		elif  command -v "7z" &> /dev/null; then
		    7z x -o"$BW_SRC" "$BW_SRC.zip"
		elif command -v "p7zip" &> /dev/null; then
		    p7zip x -o"$BW_SRC" "$BW_SRC.zip"
		else
		    berror "No zipping software, could not unpack archive!"
		    exit
		fi
	fi

	# [BOOTSTRAPPING - BITWARDEN] Symlink ~/.local/src to ~/.local/bin
	if [[ ! -e "$BW_BIN" ]]; then
		information "Symlinking binary to $BW_BIN"
		ln -s "$BW_SRC/bw" "$BW_BIN"
	fi

	# [BOOTSTRAPPING - BITWARDEN] Set executable flag
	if [[ ! -x "$BW_BIN" ]]; then
		# Set executable flag
		chmod +x "$BW_BIN"
		information "Executable flag set"
	fi
fi

# [BITWARDEN] Login to Bitwarden
if ! bw --nointeraction --quiet login --check; then
    binformation "Login to Bitwarden"
    export BW_SESSION=$(bw login --raw)
elif ! bw --nointeraction --quiet unlock --check; then
    binformation "Unlock to Bitwarden"
    export BW_SESSION=$(bw unlock --raw)
fi

# [CHEZMOI] Check for existing installation
if [[ -e "$HOME/.local/share/chezmoi" ]]; then
    bwarning "Chezmoi is already installed, removing..."
    rm -r -f ~/.local/share/chezmoi
fi

# [CHEZMOI] Download
binformation "Downloading chezmoi..."
export BINDIR="$HOME/.local/bin"
sh -c "$(curl -fsLS git.io/chezmoi)"

# [CHEZMOI] Init
chezmoi init quitlox

# [CHEZMOI] Get Age (File Encryption) key from Bitwarden
information "Retrieving encryption key..."
bw --nointeraction get attachment "chezmoi_encryption_key.txt" --itemid b33b9474-c3ba-4961-abef-ade1010e1597 --output "$(chezmoi source-path)/private_dot_ssh/.chezmoi_encryption_key.txt"

# [CHEZMOI] Apply
chezmoi apply

# [Post] Setup Atuin
if ! command -v "atuin" &> /dev/null; then
    binformation "Logging in to Atuin..."
    # Ohno what did I do xD
    key=$(bw get item "Atuin: Login" --pretty --raw | grep '"name": "key"' -A 1 | awk '/value/ { gsub(/ /,""); split($0,a,":"); print a[2] }' | cut -c 2- | rev | cut -c 3- | rev)
    atuin login -u quitlox -p $(bw get password "Atuin: Login") -k $key
fi

# [Post] Change URL chezmoi repo (from http to ssh)
binformation "Changing git repo origin of chezmoi"

eval $(ssh-agent)
ssh-add ~/.ssh/key_quitlox
if (cd ~/.local/share/chezmoi && git remote set-url origin git@github.com:Quitlox/dotfiles.git); then
    success "Successfully updated the remote of ~/.local/share/chezmoi"
fi

# [Post] Theming
binformation "Configuring theme..."
if command -v "flavours" &> /dev/null; then
    information "Updating flavours..."
    flavours update all
    information "Setting theme..."
    zsh ~/.config/dotfiles/themes/astronaut/set.sh
fi

# TODO
# LightDM: Set greeter to lightdm-webkit2-greeter
# LightDM: Wait for graphics
# Graphic drivers

# [Post] Multilib
binformation "Enable 'multilib' repositories"
information "\tuncomment the following lines in '/etc/pacman.conf'"
log "\t\t[multilib]"
log "\t\tInclude = /etc/pacman.d/mirrorlist"

# [Post] Numlock
binformation "To activate numlock on startup:"
information "\tyay -S mkinitcpio-numlock"
information "\tadd 'numlock' to 'HOOKS' in '/etc/mkinitcpio.conf' (after 'encrypt')"
information "\tregenerate initial ramdisk: 'mkinitcpio -p linux'"

# [Post] SSD - Trim
bwarning "Do not to forget to enable TRIM for your SSD if supported"
warning "run 'lsblk --discard'; non-zero values for both DISC-GRAN and DISC-MAX indicate TRIM support. Then:"
warning "sudo pacman -S util-linux"
warning "sudo systemctl enable --now fstrim.timer"