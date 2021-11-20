#!/bin/bash

Color_Off='\033[0m'       # Text Reset

Blue='\033[0;34m'         # Blue
BBlue='\033[1;34m'        # Bold Blue
Yellow='\033[0;33m'       # Yellow
BYellow='\033[1;33m'      # Bold Yellow
Red='\033[0;31m'          # Red
BRed='\033[1;31m'         # Bold Red

# VARIABLES
BW_BIN="$HOME/.local/bin/bw"

# [BOOTSTRAPPING - DIRECTORIES]
[[ ! -e "$HOME/.local" ]] && mkdir "$HOME/.local" && echo "=> Created folder ~/.local"
[[ ! -e "$HOME/.local/src" ]] && mkdir "$HOME/.local/src" && echo "=> Created folder ~/.local/src"
[[ ! -e "$HOME/.local/bin" ]] && mkdir "$HOME/.local/bin" && echo "${Blue}=> Created folder ~/.local/bin${Color_Off}"

# [BOOTSTRAPPING - PATH]
if [[ ! ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
	echo -e "${BBlue}=> Adding ~/.local/bin to \$PATH${Color_Off}"
	export PATH=$PATH:$HOME/.local/bin
fi

# [BOOTSTRAPPING - 7zip]
if ! command -v "7z"
then
	if [[ $(uname -r) == *"MANJARO"* ]]; then
		sudo pacman -S p7zip
	else
		echo -e "${BRed}=> Please install p7zip!${Color_Off}"
	fi
fi

# [BOOTSTRAPPING - BITWARDEN]
if ! command -v bw &> /dev/null
then
	# [BOOTSTRAPPING - BITWARDEN]
	echo -e "${BBlue}Bitwarden not installed, bootstrapping Bitwarden...${Color_Off}"

	# [BOOTSTRAPPING - BITWARDEN] Get tag of latest release
	TAG=$(curl -u "quitlox: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" -L --silent "https://api.github.com/repos/bitwarden/cli/releases/latest" \
		| grep '"tag_name":' \
		| sed -E 's/.*"([^"]+)".*/\1/')
	BW_SRC="$HOME/.local/src/bitwardencli/bw-${TAG}"
	echo -e "${Blue}=> Found release: ${TAG}${Color_Off}"

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
	ASSET_ID=$(curl -u "quitlox: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" -L -H "Accept: application/vnd.github.v3+json" \
		"https://api.github.com/repos/bitwarden/cli/releases/tags/v1.19.1" \
			| grep -B 3 '"name"' \
			| grep -B 3 'linux.*.zip' \
			| awk '/"id"/ { print $2 }' \
			| sed 's/,//')
	echo -e "${Blue}=> Found asset: ${ASSET_ID}${Color_Off}"


	# [BOOTSTRAPPING - BITWARDEN] Download latest release
	if [[ ! -e "$BW_ZIP.zip" ]]; then
		# No, so download the latest asset

		# Create directory if non-existant
		[[ ! -e "$HOME/.local/src/bitwardencli" ]] && mkdir "$HOME/.local/src/bitwardencli" && echo "=> Created folder ~/.local/src/bitwardencli"

		# Download...
		echo -e "${Blue}=> Downloading...${Color_Off}"
		curl -u "quitlox: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" -L -H "Accept: application/octet-stream" \
			"https://api.github.com/repos/bitwarden/cli/releases/assets/48085900" \
			--output "$BW_SRC.zip"
	else
		echo -e "${Yellow}=> Latest release already downloaded!${Color_Off}"
	fi

	# [BOOTSTRAPPING - BITWARDEN] Extract the binary
	if [[ ! -e "$BW_SRC" ]]; then
		echo -e "${Blue}=> Extracting binary $BW_SRC.zip${Color_Off}"
		7z x -o"$BW_SRC" "$BW_SRC.zip"
	fi

	# [BOOTSTRAPPING - BITWARDEN] Symlink ~/.local/src to ~/.local/bin
	if [[ ! -e "$BW_BIN" ]]; then
		echo -e "${Blue}=> Symlinking binary to $BW_BIN${Color_Off}"
		ln -s "$BW_SRC/bw" "$BW_BIN"
	fi

	# [BOOTSTRAPPING - BITWARDEN] Set executable flag
	if [[ ! -x "$BW_BIN" ]]; then
		# Set executable flag
		chmod +x "$BW_BIN"
		echo -e "${Blue}=> Executable flag set${Color_Off}"
	fi
fi

# [BITWARDEN] Login to Bitwarden
echo -e "${BBlue}Login to Bitwarden${Color_Off}"
export BW_SESSION=$(bw unlock --raw)

# [CHEZMOI] Get Age (File Encryption) key from Bitwarden
bw get attachment "chezmoi_encryption_key.txt" --itemid b33b9474-c3ba-4961-abef-ade1010e1597 --output "$(chezmoi source-path)/private_dot_ssh/.chezmoi_encryption_key.txt"
