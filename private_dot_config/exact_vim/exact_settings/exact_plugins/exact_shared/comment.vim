"#######################################
"### COMMENT: TCOMMENT               ###
"#######################################

" Manual Mappings
" let g:tcomment_maps = 0
" nmap <silent><leader>c <Plug>TComment_gc
" nnoremap <silent><leader>cc <Plug>TComment_gcc
" nnoremap <silent><leader>c< <Plug>TComment_Uncomment
" nnoremap <silent><leader>c<c <Plug>TComment_Uncommentc
" nnoremap <silent><leader>c<b <Plug>TComment_Uncommentb
" nnoremap <silent><leader>c> <Plug>TComment_Comment
" nnoremap <silent><leader>c>c <Plug>TComment_Commentc
" nnoremap <silent><leader>c>b <Plug>TComment_Commentb

if !has('nvim')
""""""""""""""""""""""""""""""""""""""""
""" VIM
""""""""""""""""""""""""""""""""""""""""
let g:which_key_map.g = {
            \ 'name': '+comment',
            \ 'cc': 'toggle comment for current line',
            \ 'c<': 'uncomment region',
            \ 'c<c': 'uncomment current line',
            \ 'c<b': 'uncomment region as block',
            \ 'c>': 'comment region',
            \ 'c>c': 'comment current line',
            \ 'c>b': 'comment region as block',
            \ }
else
""""""""""""""""""""""""""""""""""""""""
""" NEOVIM
""""""""""""""""""""""""""""""""""""""""
lua << EOF
local wk = require('which-key')
wk.register({
    g = {
        ["<"] = { name = "Explicit Uncomment", c = "Uncomment current line", b = "Uncomment current block" },
        [">"] = { name = "Explicit Comment", c = "Comment current line", b = "Comment current block" },
        c = "Toggle comment",
    },
}, { noremap = true })
EOF
endif
