
"#######################################
"### KEYBINDINGS: FILE               ###
"#######################################

noremap <leader>fw :w<cr>
noremap <leader>fW :wa<cr>
nnoremap <leader>ft :NERDTreeMirror<CR>:NERDTreeToggle<CR>
nnoremap <leader>fl :NERDTreeFind<CR>
nnoremap <leader>ff :AutoFormat

"#######################################
"### KEYBINDINGS: WINDOW             ###
"#######################################

" Window:
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
nnoremap <leader>wrk :resize +2<CR>
nnoremap <leader>wrj :resize -2<CR>
nnoremap <leader>wrl :vertical resize -2<CR>
nnoremap <leader>wrh :vertical resize +2<CR>
nnoremap <Up> :resize +2<CR>
nnoremap <Down> :resize -2<CR>
nnoremap <Right> :vertical resize +2<CR>
nnoremap <Left> :vertical resize -2<CR>

"#######################################
"### KEYBINDINGS: BUFFER             ###
"#######################################

map <leader>bd :Bclose<cr>
map <leader>bn :bnext<cr>
map <leader>bp :bprevious<cr>
map <leader>bo :BufOnly<cr>

"#######################################
"### KEYBINDINGS: TABS               ###
"#######################################

map <leader>tt :tabnew
map <leader>to :tabonly<cr>
map <leader>td :tabclose<cr>
map <leader>tn :tabnext<cr>
map <leader>tp :tabprevious<cr>

" Tabs: last
let g:lasttab = 1
map <leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Tabs: Move
map <leader>tmh :-tabmove<cr>
map <leader>tml :+tabmove<cr>


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

