
"#######################################
"### SETTINGS                        ###
"#######################################

let g:vimtex_compiler_method = 'tectonic'
let g:vimtex_quickfix_method = 'pplatex'
let g:vimtex_view_method = 'zathura'

let g:vimtex_syntax_conceal = {
            \ 'accents': 1,
            \ 'cites': 1,
            \ 'fancy': 0,
            \ 'greek': 1,
            \ 'math_bounds': 1,
            \ 'math_delimiters': 1,
            \ 'math_fracs': 1,
            \ 'math_super_sub': 1,
            \ 'math_symbols': 1,
            \ 'sections': 0,
            \ 'styles': 1,
            \}

"#######################################
"### KEYBINDINGS                     ###
"#######################################

noremap <leader>ll :VimtexCompile<cr>
noremap <leader>lv :VimtexView<cr>
noremap <leader>le :VimtexErrors<cr>
noremap <leader>lc :VimtexClean<cr>
noremap <leader>ls :call ToggleVimtexConceal()<cr>

"#######################################
"### HELPER FUNCTIONS                ###
"#######################################

function! ToggleVimtexConceal()
    if &conceallevel==0
        set conceallevel=2
    else
        set conceallevel=0
    endif
endfunction

