
" This file is for keybindings to the vim editing experience itself, i.e.
" those without the leader key.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Leader
nnoremap <Space> <Nop>
let g:mapleader = " "
let g:maplocalleader = "\\"

" Saving
map <C-s> :w<CR>
map <C-S> :wa<CR>

" Ctrl+Backspace deletes word
inoremap <C-BS> <C-w>
inoremap <C-h> <C-w>
cnoremap <C-BS> <C-w>
cnoremap <C-h> <C-w>

" Remove some default mappings that conflict
map K <Nop>
map [f <Nop>
map ]f <Nop>

" Disable some default keybindings
" nnoremap q: <Nop>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim Editing and Navigation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remap 0 to first non-blank character
" noremap 0 ^
" noremap ^ 0

" Yank from cursor position to end-of-line
" This is default in Neovi
nnoremap Y y$
" Make paste reselect yank
xnoremap p pgvy
" Ensure cursor stays in place when janking selection
vnoremap y ygv<Esc>

" Keep cursor centered when jumping
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
" nnoremap <C-u> <C-u>zz
" nnoremap <C-d> <C-d>zz

" ... and fix code navigation with softwrapping
" nnoremap j gjzz
" nnoremap gj jzz
" nnoremap k gkzz
" nnoremap gk kzz
noremap j gj
noremap gj j
noremap k gk
noremap gk k

" augroup center_cursor
"     autocmd!
"     autocmd FileType * nnoremap <buffer> <C-u> <C-u>zz
"     autocmd FileType Neotree,Outline nnoremap <buffer> <C-u> <C-u>
"
"     autocmd FileType * nnoremap <buffer> <C-d> <C-d>zz
"     autocmd FileType Neotree,Outline nnoremap <buffer> <C-d> <C-d>
"
"     " ... and fix code navigation with softwrapping
"     autocmd FileType * nnoremap <buffer> j gjzz
"     autocmd FileType Neotree,Outline nunmap <buffer> j | nnoremap <buffer> j gj
"     autocmd FileType * nnoremap <buffer> gj jzz
"     autocmd FileType Neotree,Outline nunmap <buffer> gj | nnoremap <buffer> gj jzz
"     autocmd FileType * nnoremap <buffer> k gkzz
"     autocmd FileType Neotree,Outline nunmap <buffer> k | nnoremap <buffer> k gk
"     autocmd FileType * nnoremap <buffer> gk kzz
"     autocmd FileType Neotree,Outline nunmap <buffer> gk | nnoremap <buffer> gk k
" augroup


" Undo breakpoints
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" Re-select blocks after indenting in visual/select mode
xnoremap < <gv
xnoremap > >gv|
vnoremap = =gv

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
vnoremap <C-h> <C-w>h
vnoremap <C-j> <C-w>j
vnoremap <C-k> <C-w>k
vnoremap <C-l> <C-w>l

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Source: https://vim.fandom.com/wiki/Moving_lines_up_or_down
" Move a line of text using ALT+[jk]
" NOTE: Some terminals (e.g. URxvt) are not by default
"       compatible with <M-X> mappings. See
"       'terminal_specific.vim' for work-around.
if !has('nvim')
    nnoremap <M-j> :m .+1<CR>==
    nnoremap <M-k> :m .-2<CR>==
    inoremap <M-j> <Esc>:m .+1<CR>==gi
    inoremap <M-k> <Esc>:m .-2<CR>==gi
    vnoremap <M-j> :m '>+1<CR>gv=gv
    vnoremap <M-k> :m '<-2<CR>gv=gv
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual Mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

vnoremap : :<C-U>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command Mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" $q is super useful when browsing on the command line
" it deletes everything until the last slash
cno <C-Q> <C-\>eDeleteTillSlash()<cr>

" Bash like keys for the command line
cnoremap <C-A>		<Home>
cnoremap <C-E>		<End>
cnoremap <C-K>		<C-U>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

