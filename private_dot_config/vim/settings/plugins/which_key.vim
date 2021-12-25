if has('nvim') | finish | endif

"#######################################
"### SETTINGS                        ###
"#######################################

let g:which_key_use_floating_win = 0

" Vim-which-key
call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
let g:which_key_map = {}

""""""""""""""""""""""""""""""""""""""""
" => KEYBINDINGS: NAGIVATION
""""""""""""""""""""""""""""""""""""""""

let g:which_key_map.f = { 'name': '+file' }

let g:which_key_map.f.w = '[f]ile [w]rite'
let g:which_key_map.f.W = '[f]ile [W]rite All'
let g:which_key_map.f.t = '[f]ile [t]ree'
let g:which_key_map.f.l = '[f]ile [l]ocate'
let g:which_key_map.f.f = '[f]ile [f]ormat'

let g:which_key_map.w = { 'name': '+window' }
let g:which_key_map.w.j = 'focus [w]indow down'
let g:which_key_map.w.k = 'focus [w]indow up'
let g:which_key_map.w.h = 'focus [w]indow left'
let g:which_key_map.w.l = 'focus [w]indow right'
let g:which_key_map.w.o = '[w]indow [o]nly'
let g:which_key_map.w.v = '[w]indow split vertical'
let g:which_key_map.w.b = '[w]indow split horizontal'
let g:which_key_map.w.d = '[w]indow [d]elete'
let g:which_key_map.w.w = ':new <window>'

let g:which_key_map.w.r = { 'name': '+resize' }
let g:which_key_map.w.r.k = '[w]indow [r]esize up'
let g:which_key_map.w.r.j = '[w]indow [r]esize down'
let g:which_key_map.w.r.h = '[w]indow [r]esize left'
let g:which_key_map.w.r.l = '[w]indow [r]esize right'
let g:which_key_map["<Up>"] = 'which_key_ignore'
let g:which_key_map["<Down>"] = 'which_key_ignore'
let g:which_key_map["<Right>"] = 'which_key_ignore'
let g:which_key_map["<Left>"] = 'which_key_ignore'

let g:which_key_map.b = { 'name': '+buffer' }

let g:which_key_map.b.D = '[b]uffer [D]elete All'
let g:which_key_map.b.n = '[b]uffer [n]ext'
let g:which_key_map.b.p = '[b]uffer [p]revious'
let g:which_key_map.b.o = '[b]uffer [o]nly'

"let g:which_key_map.t = { 'name': '+tab' }

"let g:which_key_map.t.t = '[t]ab <tab>'
"let g:which_key_map.t.o = '[t]ab [o]nly'
"let g:which_key_map.t.d = '[t]ab [d]elete'
"let g:which_key_map.t.n = '[t]ab [n]next'
"let g:which_key_map.t.p = '[t]ab [p]revious'
"let g:which_key_map.t.l = '[t]ab [l]ast'

"let g:which_key_map.t.m = { 'name': '+move' }

"let g:which_key_map.t.m.h = '[t]ab left'
"let g:which_key_map.t.m.h = '[t]ab right'

""""""""""""""""""""""""""""""""""""""""
" => KEYBINDINGS: TOGGLES
""""""""""""""""""""""""""""""""""""""""

let g:which_key_map.T = { 'name': '+toggle' }

let g:which_key_map.T.g = '[T]oggle [g]uides'
let g:which_key_map.T.c = '[T]oggle [c]lose tag'
let g:which_key_map.T.r = '[T]oggle [r]ainbow parentheses'
let g:which_key_map.T.p = '[T]oggle [p]encil'

let g:which_key_map.t = { 'name': '+UI-Toggle' }

let g:which_key_map.t.t = '[t]oggle [t]agbar'
let g:which_key_map.t.f = '[t]oggle [f]iletree'
let g:which_key_map.t.f = '[t]oggle go[y]o'

""""""""""""""""""""""""""""""""""""""""
" => KEYBINDINGS: GENERAL
""""""""""""""""""""""""""""""""""""""""

let g:which_key_map["<CR>"] = 'which_key_ignore'

let g:which_key_map.g = { 'name': '+go' }
let g:which_key_map.g.y = '[g]o[y]o'
let g:which_key_map.g.w = '[g]o strip [w]hitespace'

let g:which_key_map.v = { 'name': '+vim' }
let g:which_key_map.v.s = '[v]im [s]ource vimrc'
let g:which_key_map.v.u = '[v]im [u]pdate plugins'

""""""""""""""""""""""""""""""""""""""""
" => PLUGIN: COMMENTARY
""""""""""""""""""""""""""""""""""""""""

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

""""""""""""""""""""""""""""""""""""""""
" => PLUGIN: NERDTree
""""""""""""""""""""""""""""""""""""""""

let g:which_key_map.o = { 'name': '+open' }
let g:which_key_map.o.f = '[o]pen [f]ile'
let g:which_key_map.o.b = '[o]pen [b]uffer'
let g:which_key_map.o.r = '[o]pen [r]ecent'

""""""""""""""""""""""""""""""""""""""""
" => PLUGIN: LATEX
""""""""""""""""""""""""""""""""""""""""

let g:which_key_map.l = {'name': '+LaTeX'}
let g:which_key_map.l.l = '[l]atex compile'
let g:which_key_map.l.v = '[l]atex [v]iew'
let g:which_key_map.l.e = '[l]atex [e]rrors'
let g:which_key_map.l.c = '[l]atex [c]lean'
let g:which_key_map.l.c = '[l]atex conceal [s]yntax'

"#######################################
"### BEHAVIOUR                       ###
"#######################################

autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
            \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
