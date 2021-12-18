
"#######################################
"### SETTINGS                        ###
"#######################################

" Disable default mapping
let g:ctrlp_map = ''
" Ignore certain files in result
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
" List results top-to-bottom
let g:ctrlp_match_window = 'order:ttb'
" Scan for hidden files and directories
let g:ctrlp_show_hidden = 1
" Make new files replace the current window
let g:ctrlp_open_new_file = 'r'

"#######################################
"### KEYBINDINGS                     ###
"#######################################

" Extra mappings: [o]pen
noremap <C-o> :NERDTreeClose\|CtrlP<cr>
let g:which_key_map.o = { 'name': '+open' }
noremap <leader>oo :NERDTreeClose\|CtrlP<cr>
let g:which_key_map.o.f = '[o]pen [f]ile'
noremap <leader>ob :NERDTreeClose\|CtrlPBuffer<cr>
let g:which_key_map.o.b = '[o]pen [b]uffer'
noremap <leader>or :NERDTreeClose\|CtrlPMRU<cr>
let g:which_key_map.o.r = '[o]pen [r]ecent'

