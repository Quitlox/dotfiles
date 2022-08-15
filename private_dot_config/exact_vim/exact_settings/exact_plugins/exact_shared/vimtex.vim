
"#######################################
"### Vimtex Plugin                   ###
"#######################################

""""""""""""""""""""""""""""""""""""""""
" => Settings
""""""""""""""""""""""""""""""""""""""""

" In Neovim, we use the lsp
if !has('nvim')
    let g:vimtex_syntax_enabled=0
    let g:vimtex_complete_enabled=0
endif

" Backends
let g:vimtex_quickfix_method = 'pplatex'
let g:vimtex_view_method = 'zathura'

" Quickfix
"let g:vimtex_quickfix_autojump = 1
"let g:vimtex_quickfix_mode = 1

" Editor
let g:matchup_override_vimtex = 1
" Documentation
let g:vimtex_doc_handlers = ['vimtex#doc#handlers#texdoc']
" Indent
let g:vimtex_indent_conditionals = {
      \ 'open': '\v%(%(\\newif)@<!\\if%(f>|field|name|numequal|thenelse)@!)|%(\\pcfor>)',
      \ 'else': '\\else\>',
      \ 'close': '%(\\fi\>)|%(\\pcendfor\>)',
      \}

" Conceal
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
            \ 'sections': 1,
            \ 'styles': 1,
            \}

" Ignore useless quickfix
let g:vimtex_quickfix_ignore_filters = [
      \ 'Underfull \\hbox',
      \ 'Overfull \\hbox',
      \ 'LaTeX Warning: .\+ float specifier changed to',
      \ 'LaTeX hooks Warning',
      \ 'Package siunitx Warning: Detected the "physics" package:',
      \ 'Package hyperref Warning: Token not allowed in a PDF string',
      \]

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

" (Fail to) conceal kets and bras
au FileType tex syntax match texMathSymbol '\\bra{\%([^{]*{[^}]*}[^}]*}\|[^}]*}\)\@=' contained conceal cchar=<
au FileType tex syntax match texMathSymbol '\%(\\bra{[^{]*{[^}]*}[^}]*}\|[^}]*\)\@<=}' contained conceal cchar=|
au FileType tex syntax match texMathSymbol '\\ket{\%([^{]*{[^}]*}[^}]*}\|[^}]*}\)\@=' contained conceal cchar=|
au FileType tex syntax match texMathSymbol '\%(\\ket{[^{]*{[^}]*}[^}]*}\|[^}]*\)\@<=}' contained conceal cchar=>
au FileType tex syntax match texMathSymbol /\\braket{\%([^{]*{[^}]*}[^}]*}\|[^}]*}\)\@=/ contained conceal cchar=<
au FileType tex syntax match texMathSymbol /\%(\\braket{[^{]*{[^}]*}[^}]*}\|[^}]*\)\@<=}/ contained conceal cchar=>

