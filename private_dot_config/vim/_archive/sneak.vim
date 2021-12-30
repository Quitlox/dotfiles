
"#######################################
"### Sneak (vimrc)                   ###
"#######################################

" Plugin: Sneak
" Link: https://vimawesome.com/plugin/vim-sneak
" Official Description: Jump to any location specified by
" two characters.
"
" Adds a new motions to the 's' key. The motion is basically
" 'f' but with two characters. This motion does not conflict
" with 'vim-surround' (also bound to 's'), since the latter
" is a verb instead of a motion.
call dein#add('justinmk/vim-sneak')

"#######################################
"### Sneak (/plugins)                ###
"#######################################

if !(dein#is_available(['vim-sneak'])) | finish | endif

""""""""""""""""""""""""""""""""""""""""
" => Settings
""""""""""""""""""""""""""""""""""""""""

map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

""""""""""""""""""""""""""""""""""""""""
" => Behaviour
""""""""""""""""""""""""""""""""""""""""

autocmd User SneakLeave highlight clear Sneak
"highlight Sneak gui=bold guifg=black guibg=yellow ctermfg=black ctermbg=yellow

