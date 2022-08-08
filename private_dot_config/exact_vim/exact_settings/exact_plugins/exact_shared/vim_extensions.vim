
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Clever F
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""" VIM """
if !has('nvim') && dein#is_available(['clever-f.vim'])
    map ; <Plug>(clever-f-repeat-forward)
    map , <Plug>(clever-f-repeat-back)
endif

""" NEOVIM """
if has('nvim')
lua << EOF
vim.keymap.set('n', ';', "<Plug>(clever-f-reapeat-forward)")
vim.keymap.set('n', ',', "<Plug>(clever-f-reapeat-back)")
EOF
endif

