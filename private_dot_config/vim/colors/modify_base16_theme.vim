#!/bin/sh

# The base16_theme.vim file is partly managed by Base16 Manager.
# The file contains the markers
# 	" <<<<<<<<<<
# 	" >>>>>>>>>>
# between which Base16 Manager writes in theme.
#
# This script overwrites the ~/.config/vim/colors/base16_theme.vim
# file using the .source.base16_theme.vim file in the repository
# and restores the content between the markers.

sed -n '/^" <<<<<<<<<</,/^\" >>>>>>>>>>/{/^" <<<<<<<<<</!{/^\" >>>>>>>>>>/!p;};}' \
	| sed  '/\" <<<<<<<<<</r /dev/stdin' $(chezmoi source-path)/private_dot_config/vim/colors/.source.base16_theme.vim
