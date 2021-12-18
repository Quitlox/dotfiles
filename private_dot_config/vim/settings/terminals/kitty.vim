if !(&term == 'xterm-kitty' || &term == 'kitty') | finish | endif

" Bug in Vim terminal handling can cause issues with Vim-Devicons
" Link: https://github.com/ryanoasis/vim-devicons/issues/266#issuecomment-599166010
set t_RV=
set term=kitty


