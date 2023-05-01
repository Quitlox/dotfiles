""""""""""""""""""""""""""""""""""""""""
" => PLUGIN: FUGITIVE
""""""""""""""""""""""""""""""""""""""""

let g:which_key_map.g = { 'name': '+git' }
let g:which_key_map.g.s = '[g]it [s]tatus'
let g:which_key_map.g.c = '[g]it [c]ommit'
let g:which_key_map.g.j = '[g]it :diffget //3'
let g:which_key_map.g.f = '[g]it :diffget //2'

nnoremap <leader>gs :G<cr>
nnoremap <leader>gc :Git commit<cr>
nnoremap <leader>gj :diffget //3<cr>
nnoremap <leader>gf :diffget //2<cr>

