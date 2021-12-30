
"#######################################
"### Vimtex Plugin                   ###
"#######################################

""""""""""""""""""""""""""""""""""""""""
" => Settings
""""""""""""""""""""""""""""""""""""""""

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

""""""""""""""""""""""""""""""""""""""""
" => Helper Functions
""""""""""""""""""""""""""""""""""""""""

function! ToggleVimtexConceal()
    if &conceallevel==0
        set conceallevel=2
    else
        set conceallevel=0
    endif
endfunction

"#######################################
"### File Settings                   ###
"#######################################

" Do not overwrite default concealcursor options
" IndentLine sets concealcursor=inc
" For latex we want concealcursor=c
let g:indentLine_setConceal = 0
" Do not overwrite default syntax highlighting
let g:indentLine_setColors = 0

au FileType tex let b:delimitMate_matchpairs = "[:],{:},<:>"
au FileType tex syntax match texMathSymbol '\\bra{\%([^{]*{[^}]*}[^}]*}\|[^}]*}\)\@=' contained conceal cchar=<
au FileType tex syntax match texMathSymbol '\%(\\bra{[^{]*{[^}]*}[^}]*}\|[^}]*\)\@<=}' contained conceal cchar=|
au FileType tex syntax match texMathSymbol '\\ket{\%([^{]*{[^}]*}[^}]*}\|[^}]*}\)\@=' contained conceal cchar=|
au FileType tex syntax match texMathSymbol '\%(\\ket{[^{]*{[^}]*}[^}]*}\|[^}]*\)\@<=}' contained conceal cchar=>
au FileType tex syntax match texMathSymbol /\\braket{\%([^{]*{[^}]*}[^}]*}\|[^}]*}\)\@=/ contained conceal cchar=<
au FileType tex syntax match texMathSymbol /\%(\\braket{[^{]*{[^}]*}[^}]*}\|[^}]*\)\@<=}/ contained conceal cchar=>
