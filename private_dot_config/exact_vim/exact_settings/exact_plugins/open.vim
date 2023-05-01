if has('nvim') | finish | endif

" The OPEN command mapped to the 'o' key is meant to quickly open or navigate
" to item via a popup-like ui.
"
" In vim, we use the CtrlP plugin to achieve this functionality.

""""""""""""""""""""""""""""""""""""""""
" => CTRLP: SETTINGS
""""""""""""""""""""""""""""""""""""""""

" Disable default mapping
let g:ctrlp_map = ''
" List results top-to-bottom
let g:ctrlp_match_window = 'order:ttb'
" Scan for hidden files and directories
let g:ctrlp_show_hidden = 1
" Make new files replace the current window
let g:ctrlp_open_new_file = 'r'

""""""""""""""""""""""""""""""""""""""""
" => CTRLP: OPEN
""""""""""""""""""""""""""""""""""""""""

let g:which_key_map.o = { 'name': '+open' }
let g:which_key_map.o.f = '[o]pen [f]ile'
let g:which_key_map.o.b = '[o]pen [b]uffer'
let g:which_key_map.o.r = '[o]pen [r]ecent'
let g:which_key_map.o.c = '[o]pen [c]ommands'

noremap <leader>of :NERDTreeClose\|CtrlP<cr>
noremap <leader>ob :NERDTreeClose\|CtrlPBuffer<cr>
noremap <leader>or :NERDTreeClose\|CtrlPMRU<cr>
nnoremap <silent><nowait> <leader>oc :<C-u>CocList commands<cr>

