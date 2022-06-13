if has('nvim') | finish | endif

""""""""""""""""""""""""""""""""""""""""
" => SETTINGS
""""""""""""""""""""""""""""""""""""""""

" Floating window is ugly in default vim
let g:which_key_use_floating_win = 0
" Fix ugly highlight of seperator
highlight default link WhichKeySeperator Normal

" Vim-which-key
let g:which_key_map = {}
let g:which_key_local_map = {}
let g:which_key_go_map = {}
call which_key#register('<Space>', "g:which_key_map")
call which_key#register(',', "g:which_key_local_map")
call which_key#register('g', "g:which_key_go_map")
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader>      :<c-u>WhichKey ','<CR>

""""""""""""""""""""""""""""""""""""""""
" => KEYBINDINGS
""""""""""""""""""""""""""""""""""""""""

let g:which_key_map.s = ':wa'
noremap <leader>s :wa<cr>

""""""""""""""""""""""""""""""""""""""""
" => KEYBINDINGS: WINDOW
""""""""""""""""""""""""""""""""""""""""

" Window:
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

map <leader>wj <C-W>j
map <leader>wk <C-W>k
map <leader>wh <C-W>h
map <leader>wl <C-W>l
map <leader>wo <C-W>o
map <leader>wv <C-W>s
map <leader>wb <C-W>v
map <leader>wd <C-W>q
map <leader>ww :new<CR>

" Window_Resize:
let g:which_key_map.w.r = { 'name': '+resize' }
let g:which_key_map.w.r.k = '[w]indow [r]esize up'
let g:which_key_map.w.r.j = '[w]indow [r]esize down'
let g:which_key_map.w.r.h = '[w]indow [r]esize left'
let g:which_key_map.w.r.l = '[w]indow [r]esize right'
let g:which_key_map["<Up>"] = 'which_key_ignore'
let g:which_key_map["<Down>"] = 'which_key_ignore'
let g:which_key_map["<Right>"] = 'which_key_ignore'
let g:which_key_map["<Left>"] = 'which_key_ignore'

nnoremap <leader>wrk :resize +2<CR>
nnoremap <leader>wrj :resize -2<CR>
nnoremap <leader>wrl :vertical resize -2<CR>
nnoremap <leader>wrh :vertical resize +2<CR>
nnoremap <Up> :resize +2<CR>
nnoremap <Down> :resize -2<CR>
nnoremap <Right> :vertical resize +2<CR>
nnoremap <Left> :vertical resize -2<CR>

""""""""""""""""""""""""""""""""""""""""
" => KEYBINDINGS: BUFFER
""""""""""""""""""""""""""""""""""""""""

let g:which_key_map.b = { 'name': '+buffer' }

let g:which_key_map.b.d = '[b]uffer [d]elete'
let g:which_key_map.b.n = '[b]uffer [n]ext'
let g:which_key_map.b.p = '[b]uffer [p]revious'
let g:which_key_map.b.o = '[b]uffer [o]nly'
let g:which_key_map.b.s = '[b]uffer [s]ave'

map <leader>bd :Bdelete<cr>
map <leader>bn :<C-u>execute 'call Bswitch_normal(' . v:count1 . ', "next")'<CR>
map <leader>bp :<C-u>execute 'call Bswitch_normal(' . v:count1 . ', "previous")'<CR>
map <leader>bo :BufOnly<cr>
map <leader>bs :w<cr>

""""""""""""""""""""""""""""""""""""""""
" => KEYBINDINGS: TABS
""""""""""""""""""""""""""""""""""""""""

let g:which_key_map.T = { 'name': '+Tab' }

let g:which_key_map.T.t = '[T]ab <tab>'
let g:which_key_map.T.o = '[T]ab [o]nly'
let g:which_key_map.T.d = '[T]ab [d]elete'
let g:which_key_map.T.n = '[T]ab [n]next'
let g:which_key_map.T.p = '[T]ab [p]revious'
map <leader>Tt :tabnew<cr>
map <leader>To :tabonly<cr>
map <leader>Td :tabclose<cr>
map <leader>Tn :tabnext<cr>
map <leader>Tp :tabprevious<cr>


let g:which_key_map.T.l = '[T]ab [l]ast'
" Tabs: last
let g:lasttab = 1
map <leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

let g:which_key_map.T.m = { 'name': '+move' }
let g:which_key_map.T.m.h = '[T]ab left'
let g:which_key_map.T.m.h = '[T]ab right'
" Tabs: Move
map <leader>Tmh :-tabmove<cr>
map <leader>Tml :+tabmove<cr>


""""""""""""""""""""""""""""""""""""""""
" => KEYBINDINGS: TOGGLES
""""""""""""""""""""""""""""""""""""""""

let g:which_key_map.T = { 'name': '+Toggle' }

let g:which_key_map.T.f = '[T]oggle [f]iletree'
let g:which_key_map.T.s = '[T]oggle [s]ymbols'
let g:which_key_map.T.g = '[T]oggle [g]uides'
let g:which_key_map.T.c = '[T]oggle [c]lose tag'
let g:which_key_map.T.r = '[T]oggle [r]ainbow parentheses'
let g:which_key_map.T.p = '[T]oggle [p]encil'
let g:which_key_map.T.y = '[T]oggle go[y]o'

" NERDTree:
noremap <leader>Tf :NERDTreeMirror<cr>:NERDTreeToggle<cr>
" Tagbar:
noremap <leader>Ts :TagbarToggle<cr>
" Indent Guides:
noremap <leader>Tg :IndentLinesToggle<cr>
" Vim Closetag:
noremap <leader>Tc :CloseTagToggleBuffer<cr>
" Better Rainbow Parentheses:
noremap <leader>Tr :RainbowToggle<cr>
" Pencil:
noremap <leader>Tp :TogglePencil<cr>
" GoYo:
noremap <leader>Ty :Goyo<cr>

""""""""""""""""""""""""""""""""""""""""
" => KEYBINDINGS: FIND
""""""""""""""""""""""""""""""""""""""""

let g:which_key_map.f = { 'name': '+find' }

let g:which_key_map.f.l = '[f]ind [l]ocate'
nnoremap <leader>fl :NERDTreeFind<CR>

""""""""""""""""""""""""""""""""""""""""
" => KEYBINDINGS: OPEN
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

""""""""""""""""""""""""""""""""""""""""
" => KEYBINDINGS: MISCELLANEOUS
""""""""""""""""""""""""""""""""""""""""

let g:which_key_map["<CR>"] = 'which_key_ignore'

let g:which_key_map.g = { 'name': '+go' }

" Vim Better Whitespace Plugin:
let g:which_key_map.g.w = '[g]o strip [w]hitespace'
noremap gw :StripWhitespace<cr>

" Extra Mappings For Vim:
let g:which_key_map.v = { 'name': '+vim' }
let g:which_key_map.v.s = '[v]im [s]ource vimrc'
let g:which_key_map.v.u = '[v]im [u]pdate plugins'
nnoremap <leader>vs :source ~/.config/vim/vimrc<cr>
nnoremap <leader>vu :DeinUpdate<cr>


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
" => PLUGIN: COC (IDE)
""""""""""""""""""""""""""""""""""""""""

""" LEADER MAPPINGS """"""""""""""""""""
let g:which_key_map.i = { 'name': '+IDE' }
let g:which_key_map.i.d = '[i]pen [d]iagnostics'
let g:which_key_map.i.e = '[i]pen [e]xtensions'
let g:which_key_map.i.o = '[i]pen [o]utline'
let g:which_key_map.i.s = '[i]pen [s]ymbols'
let g:which_key_map.i.l = '[i]pen [l]ist'
let g:which_key_map.i.m = '[i]pen [m]arketplace'
let g:which_key_map.i.c = '[i]pen [c]ommands'

nnoremap <silent><nowait> <leader>id :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <leader>ie :<C-u>CocList extensions<cr>
nnoremap <silent><nowait> <leader>io :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <leader>is :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <leader>il :<C-u>CocList<cr>
nnoremap <silent><nowait> <leader>im :<C-u>CocList marketplace<cr>
nnoremap <silent><nowait> <leader>ic :<C-u>CocList commands<cr>

""" YANK """""""""""""""""""""""""""""""
let g:which_key_map.y = 'CoC Yanklist'
nnoremap <silent> <space>y :<C-u>CocList -A --normal yank<cr>

""" GO """""""""""""""""""""""""""""""""
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gf :call CocAction('format')<cr>
nmap <silent> ga  <Plug>(coc-codeaction)
xmap <silent> ga  <Plug>(coc-codeaction)
nmap <silent> g<enter>  <Plug>(coc-fix-current)
nmap <silent> gh :call CocAction('doHover')<cr>
nmap <silent> go :call CocAction('runCommand', 'editor.action.organizeImport')<cr>
let g:which_key_go_map.d = 'definition'
let g:which_key_go_map.y = 'type definition'
let g:which_key_go_map.i = 'implementation'
let g:which_key_go_map.r = 'references'
let g:which_key_go_map.f = 'format'
let g:which_key_go_map.a = 'code-action'
let g:which_key_go_map["<CR>"] = 'fix-current'
let g:which_key_go_map.h = 'hover'
let g:which_key_go_map.o = 'organise imports'

""""""""""""""""""""""""""""""""""""""""
" => PLUGIN: VIMTEX (LATEX)
""""""""""""""""""""""""""""""""""""""""

let g:which_key_map.l = {'name': '+LaTeX'}
let g:which_key_map.l.l = '[l]atex compile'
let g:which_key_map.l.v = '[l]atex [v]iew'
let g:which_key_map.l.e = '[l]atex [e]rrors'
let g:which_key_map.l.c = '[l]atex [c]lean'
let g:which_key_map.l.c = '[l]atex conceal [s]yntax'

noremap <leader>ll :VimtexCompile<cr>
noremap <leader>lv :VimtexView<cr>
noremap <leader>le :VimtexErrors<cr>
noremap <leader>lc :VimtexClean<cr>
noremap <leader>ls :call ToggleVimtexConceal()<cr>

""""""""""""""""""""""""""""""""""""""""
" => BEHAVIOUR
""""""""""""""""""""""""""""""""""""""""

autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
            \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
