
"#######################################
"### SETTINGS                        ###
"#######################################

" Create default mappings
let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1

"#######################################
"### KEYBINDINGS                     ###
"#######################################

map <C-_> <plug>NERDCommenterToggle

let g:which_key_map.c = {
            \ 'name': '+comment',
            \ 'c': 'comment',
            \ 'n': 'force nesting',
            \ 'm': 'minimal',
            \ 'i': 'invert',
            \ '$': 'till EOL',
            \ 'A': 'append',
            \ 'a': 'alt. delim.',
            \ 'u': 'uncomment',
            \ 's': 'sexy',
            \ 'b': 'align both',
            \ 'l': 'align left',
            \ 'y': 'yank',
            \ }


"#######################################
"### ARCHIVE: TCOMMENT               ###
"#######################################

" Extra mappings: [c]omment
"let g:tcomment_maps = 0
"nmap <silent><leader>c <Plug>TComment_gc
"nnoremap <silent><leader>cc <Plug>TComment_gcc
"nnoremap <silent><leader>c< <Plug>TComment_Uncomment
"nnoremap <silent><leader>c<c <Plug>TComment_Uncommentc
"nnoremap <silent><leader>c<b <Plug>TComment_Uncommentb
"nnoremap <silent><leader>c> <Plug>TComment_Comment
"nnoremap <silent><leader>c>c <Plug>TComment_Commentc
"nnoremap <silent><leader>c>b <Plug>TComment_Commentb
"let g:which_key_map.c = {
"            \ 'name': '+comment',
"            \ 'cc': 'toggle comment for current line',
"            \ 'c<': 'uncomment region',
"            \ 'c<c': 'uncomment current line',
"            \ 'c<b': 'uncomment region as block',
"            \ 'c>': 'comment region',
"            \ 'c>c': 'comment current line',
"            \ 'c>b': 'comment region as block',
"            \ }
