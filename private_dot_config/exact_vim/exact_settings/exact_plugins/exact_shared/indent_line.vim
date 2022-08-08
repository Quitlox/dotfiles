
" NOTE: The Neovim indent-blankline plugin also reads and uses these options

" Don't show the indentLines in the WhichKey floating window
let g:indentLine_fileTypeExclude=['WhichKey', 'WhichKeyFloat']

" Color
"let g:indentLine_defaultGroup = 'VertSplit'
"let g:indentLine_color_term = 202
"let g:indentLine_color_gui = '#A4E57E'
"let g:indentLine_color_tty_light = 4 " (default: 4)
"let g:indentLine_color_dark = 2 " (default: 2)
"let g:indentLine_bgcolor_term = 202
"let g:indentLine_bgcolor_gui = '#FF5F00'
" Character
if !has('nvim')
    let g:indentLine_char_list = ['|', '¦', '┆', '┊']
endif
