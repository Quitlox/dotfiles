""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer:
"       Kevin Witlox — @quitlox
"
" Sections:
"    -> General
"    -> Vim Editing and Navigation
"    -> Visual Mode
"    -> Command Mode
"    -> Misc
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Leader
nnoremap <Space> <Nop>
let g:mapleader = " "
let g:maplocalleader = ","

" Ctrl+Backspace deletes word
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim Editing and Navigation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remap 0 to first non-blank character
noremap 0 ^
noremap ^ 0

" Fix code navigation with softwrapping
noremap j gj
noremap gj j
noremap k gk
noremap gk k

noremap 0 g0
noremap g0 0
noremap $ g$
noremap g$ $

" Yank from cursor position to end-of-line
nnoremap Y y$
" Make paste reselect yank
xnoremap p pgvy

" Keep cursor centered when jumping
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Undo breakpoints
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" Re-select blocks after indenting in visual/select mode
xnoremap < <gv
xnoremap > >gv|
vnoremap = =gv

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Source: https://vim.fandom.com/wiki/Moving_lines_up_or_down
" Move a line of text using ALT+[jk]
" NOTE: Some terminals (e.g. URxvt) are not by default
"       compatible with <M-X> mappings. See
"       'terminal_specific.vim' for work-around.
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
inoremap <M-j> <Esc>:m .+1<CR>==gi
inoremap <M-k> <Esc>:m .-2<CR>==gi
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual Mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

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