
"#######################################
"### KEYBINDINGS: FILE               ###
"#######################################

let g:which_key_map.f = { 'name': '+file' }
noremap <leader>fw :w<cr>
let g:which_key_map.f.w = '[f]ile [w]rite'
noremap <leader>fW :wa<cr>
let g:which_key_map.f.W = '[f]ile [W]rite All'
nnoremap <leader>ft :NERDTreeMirror<CR>:NERDTreeToggle<CR>
let g:which_key_map.f.t = '[f]ile [t]ree'
nnoremap <leader>fl :NERDTreeFind<CR>
let g:which_key_map.f.l = '[f]ile [l]ocate'
nnoremap <leader>ff :AutoFormat
let g:which_key_map.f.f = '[f]ile [f]ormat'

"#######################################
"### KEYBINDINGS: WINDOW             ###
"#######################################

" Window:
let g:which_key_map.w = { 'name': '+window' }
map <leader>wj <C-W>j
let g:which_key_map.w.j = 'focus [w]indow down'
map <leader>wk <C-W>k
let g:which_key_map.w.k = 'focus [w]indow up'
map <leader>wh <C-W>h
let g:which_key_map.w.h = 'focus [w]indow left'
map <leader>wl <C-W>l
let g:which_key_map.w.l = 'focus [w]indow right'
map <leader>wo <C-W>o
let g:which_key_map.w.o = '[w]indow [o]nly'
map <leader>wv <C-W>s
let g:which_key_map.w.v = '[w]indow split vertical'
map <leader>wb <C-W>v
let g:which_key_map.w.b = '[w]indow split horizontal'
map <leader>wd <C-W>q
let g:which_key_map.w.d = '[w]indow [d]elete'
map <leader>ww :new<CR>
let g:which_key_map.w.w = ':new <window>'

" Window_Resize:
let g:which_key_map.w.r = { 'name': '+resize' }
nnoremap <leader>wrk :resize +2<CR>
let g:which_key_map.w.r.k = '[w]indow [r]esize up'
nnoremap <leader>wrj :resize -2<CR>
let g:which_key_map.w.r.j = '[w]indow [r]esize down'
nnoremap <leader>wrl :vertical resize -2<CR>
let g:which_key_map.w.r.h = '[w]indow [r]esize left'
nnoremap <leader>wrh :vertical resize +2<CR>
let g:which_key_map.w.r.l = '[w]indow [r]esize right'
nnoremap <Up> :resize +2<CR>
let g:which_key_map["<Up>"] = 'which_key_ignore'
nnoremap <Down> :resize -2<CR>
let g:which_key_map["<Down>"] = 'which_key_ignore'
nnoremap <Right> :vertical resize +2<CR>
let g:which_key_map["<Right>"] = 'which_key_ignore'
nnoremap <Left> :vertical resize -2<CR>
let g:which_key_map["<Left>"] = 'which_key_ignore'

"#######################################
"### KEYBINDINGS: BUFFER             ###
"#######################################

let g:which_key_map.b = { 'name': '+buffer' }
map <leader>bd :Bclose<cr>
let g:which_key_map.b.D = '[b]uffer [D]elete All'
map <leader>bn :bnext<cr>
let g:which_key_map.b.n = '[b]uffer [n]ext'
map <leader>bp :bprevious<cr>
let g:which_key_map.b.p = '[b]uffer [p]revious'
map <leader>bo :BufOnly<cr>
let g:which_key_map.b.o = '[b]uffer [o]nly'

"#######################################
"### KEYBINDINGS: TABS               ###
"#######################################

let g:which_key_map.t = { 'name': '+tab' }
map <leader>tt :tabnew
let g:which_key_map.t.t = '[t]ab <tab>'
map <leader>to :tabonly<cr>
let g:which_key_map.t.o = '[t]ab [o]nly'
map <leader>td :tabclose<cr>
let g:which_key_map.t.d = '[t]ab [d]elete'
map <leader>tn :tabnext<cr>
let g:which_key_map.t.n = '[t]ab [n]next'
map <leader>tp :tabprevious<cr>
let g:which_key_map.t.p = '[t]ab [p]revious'

" Tabs: last
let g:lasttab = 1
map <leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()
let g:which_key_map.t.l = '[t]ab [l]ast'

" Tabs: Move
let g:which_key_map.t.m = { 'name': '+move' }
map <leader>tmh :-tabmove<cr>
let g:which_key_map.t.m.h = '[t]ab left'
map <leader>tml :+tabmove<cr>
let g:which_key_map.t.m.h = '[t]ab right'


"#######################################
"### HELPER FUNCTIONS                ###
"#######################################

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

