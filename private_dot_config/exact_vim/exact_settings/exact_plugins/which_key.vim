""""""""""""""""""""""""""""""""""""""""
" => SETTINGS
""""""""""""""""""""""""""""""""""""""""

" Floating window is ugly in default vim
let g:which_key_use_floating_win = 1
" Fix ugly highlight of seperator
" Note: this only works if this file is sourced after the colorscheme
highlight default link WhichKeySeperator Normal

" Setup the WhichKey keybindings
let g:which_key_map = {}
let g:which_key_local_map = {}
let g:which_key_go_map = {}
call which_key#register('<Space>', "g:which_key_map")
call which_key#register(',', "g:which_key_local_map")
call which_key#register('g', "g:which_key_go_map")
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey ','<CR>

""""""""""""""""""""""""""""""""""""""""
" => BEHAVIOUR
""""""""""""""""""""""""""""""""""""""""

autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
            \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

""""""""""""""""""""""""""""""""""""""""
" => KEYBINDINGS
""""""""""""""""""""""""""""""""""""""""

let g:which_key_map.s = ':wa'
noremap <leader>s :wa<cr>

""""""""""""""""""""""""""""""""""""""""
" => KEYBINDINGS: WINDOW
""""""""""""""""""""""""""""""""""""""""

" Window:
let g:which_key_map.w = { 'name': 'Window' }
let g:which_key_map.w.j = 'which_key_ignore'
let g:which_key_map.w.k = 'which_key_ignore'
let g:which_key_map.w.h = 'which_key_ignore'
let g:which_key_map.w.l = 'which_key_ignore'
let g:which_key_map.w.o = 'Window Only'
let g:which_key_map.w.v = 'Window vSplit'
let g:which_key_map.w.b = 'Window Split'
let g:which_key_map.w.d = 'Window Delete'

map <leader>wj <C-W>j
map <leader>wk <C-W>k
map <leader>wh <C-W>h
map <leader>wl <C-W>l
map <leader>wo <C-W>o
map <leader>wv <C-W>s
map <leader>wb <C-W>v
map <leader>wd <C-W>q

" Window_Resize:
let g:which_key_map.w.r = { 'name': 'Resize' }
let g:which_key_map.w.r.k = 'Window Resize up'
let g:which_key_map.w.r.j = 'Window Resize down'
let g:which_key_map.w.r.h = 'Window Resize left'
let g:which_key_map.w.r.l = 'Window Resize right'
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
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>
nnoremap <C-Left> :vertical resize -2<CR>

""""""""""""""""""""""""""""""""""""""""
" => KEYBINDINGS: TABS
""""""""""""""""""""""""""""""""""""""""

let g:which_key_map.t = { 'name': 'Tab' }

let g:which_key_map.t.t = 'Tab new'
let g:which_key_map.t.o = 'Tab Only'
let g:which_key_map.t.d = 'Tab Delete'
let g:which_key_map.t.n = 'Tab Next'
let g:which_key_map.t.p = 'Tab Previous'
map <leader>tt :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>td :tabclose<cr>
map <leader>tn :tabnext<cr>
map <leader>tp :tabprevious<cr>

let g:which_key_map.t.m = { 'name': 'Move' }
let g:which_key_map.t.m.h = 'Tab Move Left'
let g:which_key_map.t.m.l = 'Tab Move Right'
" Tabs: Move
map <leader>tmh :-tabmove<cr>
map <leader>tml :+tabmove<cr>


""""""""""""""""""""""""""""""""""""""""
" => KEYBINDINGS: BUFFER
""""""""""""""""""""""""""""""""""""""""

" Switch buffer as expected (skip special buffers)
" https://vi.stackexchange.com/a/37045
function! Bswitch_normal(count, direction)
    " This function switches to the previous or next normal buffer excluding
    " all special buffers like quickfix or terminals
    " Modified version of https://vi.stackexchange.com/a/16710/37509
    let l:count = a:count
    let l:cmd = (a:direction ==# 'previous') ? 'bprevious' : 'bnext'
    let l:start_buffer = bufnr('%')
    while 1
        execute 'keepalt ' . l:cmd
        if &buftype == ''
            let l:count -= 1
            if l:count <= 0
                break
            endif
        endif
        " Prevent infinite loops if no buffer is a normal buffer
        if bufnr('%') == l:start_buffer && l:count == a:count
            break
        endif
    endwhile
    if bufnr('%') != l:start_buffer
        " Jump back to the start buffer once to set the alternate buffer
        execute 'buffer ' . l:start_buffer
        buffer #
    endif
endfunction

let g:which_key_map.b = { 'name': 'Buffer' }

let g:which_key_map.b.d = 'Buffer Delete'
let g:which_key_map.b.n = 'Buffer Next'
let g:which_key_map.b.p = 'Buffer Previous'
let g:which_key_map.b.o = 'Buffer Only'

map <leader>bd :Bdelete<cr>
map <leader>bn :<C-u>execute 'call Bswitch_normal(' . v:count1 . ', "next")'<CR>
map <leader>bp :<C-u>execute 'call Bswitch_normal(' . v:count1 . ', "previous")'<CR>
map <leader>bo :BufOnly<cr>

""""""""""""""""""""""""""""""""""""""""
" => KEYBINDINGS: TOGGLES
""""""""""""""""""""""""""""""""""""""""

let g:which_key_map.T = { 'name': 'Toggle' }

let g:which_key_map.T.f = 'Toggle Filetree'
let g:which_key_map.T.g = 'Toggle guides'
let g:which_key_map.T.c = 'Toggle Closetag'
let g:which_key_map.T.r = 'Toggle Raingbow'
let g:which_key_map.T.z = 'Toggle Zen'

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
" GoYo:
noremap <leader>Tz :Goyo<cr>

""""""""""""""""""""""""""""""""""""""""
" => KEYBINDINGS: MISCELLANEOUS
""""""""""""""""""""""""""""""""""""""""

let g:which_key_map["<CR>"] = 'which_key_ignore'

let g:which_key_map.g = { 'name': 'Go' }

" Vim Better Whitespace Plugin:
let g:which_key_map.g.w = 'Go Whitespace'
noremap gw :StripWhitespace<cr>

" Extra Mappings For Vim:
let g:which_key_map.v = { 'name': 'Vim' }
let g:which_key_map.v.s = 'Vim Source'
let g:which_key_map.v.u = 'Vim Update plugins'
nnoremap <leader>vs :source ~/.config/vim/vimrc<cr>
nnoremap <leader>vu :DeinUpdate<cr>


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

