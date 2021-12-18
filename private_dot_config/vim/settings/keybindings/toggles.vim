
"#######################################
"### Toggle: Functionality           ###
"#######################################

let g:which_key_map.T = { 'name': '+toggle' }

" Indent Guides:
noremap <leader>Tg :IndentLinesToggle<cr>
let g:which_key_map.T.g = '[t]oggle [g]uides'

" Vim Closetag:
noremap <leader>Tc :CloseTagToggleBuffer<cr>
let g:which_key_map.T.c = '[t]oggle [c]lose tag'

" Better Rainbow Parentheses:
noremap <leader>Tr :RainbowToggle<cr>
let g:which_key_map.T.r = '[t]oggle [r]ainbow parentheses'

" Pencil:
noremap <leader>Tp :TogglePencil<cr>
let g:which_key_map.T.p = '[t]oggle [p]encil'

"#######################################
"### Toggle: User Interface          ###
"#######################################

let g:which_key_map.t = { 'name': '+UI-Toggle' }

" Tagbar:
noremap <leader>tt :TagbarToggle<cr>
let g:which_key_map.t.t = '[t]oggle [t]agbar'

" NERDTree:
nnoremap <leader>tf :NERDTreeMirror<cr>:NERDTreeToggle<cr>
let g:which_key_map.t.f = '[t]oggle [f]iletree'


