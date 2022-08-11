""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Clever F
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if (!has('nvim') && dein#is_available(['clever-f.vim'])) || has('nvim')
    map ; <Plug>(clever-f-repeat-forward)
    map , <Plug>(clever-f-repeat-back) 
end
