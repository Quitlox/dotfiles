
"#######################################
"### File Settings                   ###
"#######################################

" Do not overwrite default concealcursor options
" IndentLine sets concealcursor=inc
" For latex we want concealcursor=c
let g:indentLine_setConceal = 0
" Do not overwrite default syntax highlighting
let g:indentLine_setColors = 0

" We do not want concealcursor in insert mode
set concealcursor=nvc

"#######################################
"### Markdown Plugin                 ###
"#######################################

let g:vim_markdown_folding_disabled = 1
