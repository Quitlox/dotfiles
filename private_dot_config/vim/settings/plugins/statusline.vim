
"#######################################
"### SETTINGS                        ###
"#######################################

" Next to statusline, also enable tabline
let g:airline#extensions#tabline#enabled = 1
" Format to use when displaying file name in tabline
let g:airline#extensions#tabline#formatter = 'unique_tail'
" Theming
let g:airline_theme = 'base16_vim'
let g:airline_powerline_fonts = 0

" Performance
let g:airline_highlighting_cache = 1
let g:airline_extensions = []