#!/bin/sh

# The theme.vim file is partly managed by Base16 Manager.
# The file contains the markers
# 	" <<<<<<<<<<
# 	" >>>>>>>>>>
# between which Base16 Manager writes in theme.
#
# This script overwrites the ~/.config/vim/colors/theme.vim
# file using the .source.theme.vim file in the repository
# and restores the content between the markers.

sed -n '/^" <<<<<<<<<</,/^\" >>>>>>>>>>/{/^" <<<<<<<<<</!{/^\" >>>>>>>>>>/!p;};}' \
	| sed  '/\" <<<<<<<<<</r /dev/stdin' $(chezmoi source-path)/private_dot_config/vim/colors/.source.theme.vim
