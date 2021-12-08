""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer:
"       Kevin Witlox — @quitlox
"
" Sections:
"    -> General
"    -> Navigation
"    -> Tabs, Windows and Buffer
"    -> Spell checking
"    -> IDE-like Functionality
"    -> Toggles
"    -> Visual Mode
"    -> Command Mode
"    -> Paranthesis/bracket
"    -> Misc
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Leader
nnoremap <Space> <Nop>
let g:mapleader = " "
let g:localleader = ","

" Ctrl+Backspace deletes word
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

" Vim-which-key
call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
let g:which_key_map = {}

" Quitting
nnoremap <leader>q :qa<cr>
let g:which_key_map.q = 'quit'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Navigation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remap 0 to first non-blank character
map 0 ^

" Fix code navigation with softwrapping
nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k
nnoremap 0 g0
nnoremap g0 0
nnoremap $ g$
nnoremap g$ $

" Yank from cursor position to end-of-line
nnoremap Y y$

" Re-select blocks after indenting in visual/select mode
xnoremap < <gv
xnoremap > >gv|
vnoremap = =gv

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>
let g:which_key_map["<CR>"] = 'remove highlight'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Source: https://vim.fandom.com/wiki/Moving_lines_up_or_down
" Move a line of text using ALT+[jk]
nnoremap <M-j> :m .+1<cr>==
nnoremap <M-k> :m .-2<CR>==
inoremap <M-j> <Esc>:m .+1<CR>==gi
inoremap <M-k> <Esc>:m .-2<CR>==gi
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv
" NOTE: Some terminals (e.g. URxvt) are not by default
"       compatible with <M-X> mappings. See
"       'terminal_specific.vim' for work-around.
"

" Change current word in a repeatable manner
nnoremap <leader>cw *``cgn
nnoremap <leader>cW *``cgN

" Change selected word in a repeatable manner
vnoremap <expr> <leader>cw "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgn"
vnoremap <expr> <leader>cW "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgN"
let g:which_key_map.c = { 'name': 'which_key_ignore' }
let g:which_key_map.p = 'which_key_ignore'
let g:which_key_map.n = 'which_key_ignore'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Tabs, Windows and Buffers
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Windows
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
map <leader>ww :new
let g:which_key_map.w.w = ':new <window>'

" Resize Windows
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
nnoremap <Down> :resize -2<CR>
nnoremap <Right> :vertical resize +2<CR>
nnoremap <Left> :vertical resize -2<CR>

" Buffers
let g:which_key_map.b = { 'name': '+buffer' }
map <leader>bd :Bclose<cr>
"let g:which_key_map.b.d = '[b]uffer [d]elete'
"map <leader>bD :bufdo bd<cr>
let g:which_key_map.b.D = '[b]uffer [D]elete All'
map <leader>bn :bnext<cr>
let g:which_key_map.b.n = '[b]uffer [n]ext'
map <leader>bp :bprevious<cr>
let g:which_key_map.b.p = '[b]uffer [p]revious'
map <leader>bo :BufOnly<cr>
let g:which_key_map.b.o = '[b]uffer [o]nly'

" Tabs
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

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Toggle spell checking
"map <leader>ts :setlocal spell!<cr>

" Spell checking shortcuts
"map <leader>sn ]s
"map <leader>sp [s
"map <leader>sa zg
"map <leader>s? z=

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => IDE-like Functionality
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:which_key_map.g = { 'name': '+go' }

" Vim Better Whitespace Plugin:
noremap gw :StripWhitespace<cr>
noremap <leader>gw :StripWhitespace<cr>
let g:which_key_map.g.w = '[g]o strip [w]hitespace'

" GoYo:
noremap gy :Goyo<cr>
noremap <leader>gy :Goyo<cr>
let g:which_key_map.g.y = '[g]o[y]o'

" YouCompleteMe:
"let g:which_key_map.g.h = '[g]o [h]over (show diagnostic)'
"let g:which_key_map.g.f = '[g]o [f]ormat'
"noremap gf :YcmCompleter Format<cr>
"noremap <leader>gf :YcmCompleter Format<cr>
"let g:which_key_map.g.o = '[g]o [o]ptimize imports'
"noremap go :YcmCompleter OrganizeImports<cr>
"noremap <leader>go :YcmCompleter OrganizeImports<cr>
"let g:which_key_map.g.r = '[g]o [r]efactor'
"noremap gr :YcmCompleter RefactorRename<cr>
"noremap <leader>gr :YcmCompleter RefactorRename<cr>
"let g:which_key_map.g.i = '[g]o to [i]mplementations'
"noremap gi :YcmCompleter GoToImplementation<cr>
"noremap <leader>gi :YcmCompleter GoToImplementation<cr>
"let g:which_key_map.g.d = '[g]o to [d]eclaration'
"noremap gd :YcmCompleter GoToDeclaration<cr>
"noremap <leader>gd :YcmCompleter GoToDeclaration<cr>
"let g:which_key_map.g.u = '[g]o to [u]sages'
"noremap gu :YcmCompleter GoToReferences<cr>
"noremap <leader>gu :YcmCompleter GoToReferences<cr>
"let g:which_key_map.g.s = '[g]o to [s]ymbol'
"noremap gs :YcmCompleter GoToSymbol<cr>
"noremap <leader>gs :YcmCompleter GoToSymbol<cr>

" Coc Tab Completion:
" Abort on Backspace
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
" Autocomplete on Tab
"inoremap <silent><expr> <Tab>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<Tab>" :
"      \ coc#refresh()
" Autocompletion on ctrl+space
inoremap <silent><expr> <c-space> coc#refresh()
" Navigate completion list backward with <S-Tab>
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Trigger Autocomplete with <C-Space>
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif
" Confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Coc Navigate Diagnostics:
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)"

" CoC Keybindings:
" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Symbol renaming
nmap gr <Plug>(coc-rename)
" Format buffer
nmap gf :call CocAction('format')<cr>
" CodeAction
nmap ga  <Plug>(coc-codeaction)
" QuickFix
nmap g<enter>  <Plug>(coc-fix-current)
" Organize Imports
nmap go :call CocAction('runCommand', 'editor.action.organizeImport')<cr>
" Documentation
nnoremap <silent> <leader>gh :call <SID>show_documentation()<CR>
" CocList
nnoremap <silent><nowait> <leader>id :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <leader>ie :<C-u>CocList extensions<cr>
nnoremap <silent><nowait> <leader>ic :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <leader>io :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <leader>is :<C-u>CocList -I symbols<cr>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" CoC Highlight Symbols:
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" CoC Miscelaneous:
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif


" CoC Yank:
nnoremap <silent> <space>y :<C-u>CocList -A --normal yank<cr>


" VimTex:
let g:which_key_map.l = {'name': '+LaTeX'}
let g:which_key_map.l.l = '[l]atex compile'
noremap <leader>ll :VimtexCompile<cr>
let g:which_key_map.l.v = '[l]atex [v]iew'
noremap <leader>lv :VimtexView<cr>
let g:which_key_map.l.e = '[l]atex [e]rrors'
noremap <leader>le :VimtexErrors<cr>
let g:which_key_map.l.c = '[l]atex [c]lean'
noremap <leader>lc :VimtexClean<cr>
let g:which_key_map.l.c = '[l]atex toggle conceal [s]yntax'
noremap <leader>ls :call ToggleVimtexConceal()<cr>

function! ToggleVimtexConceal()
    if &conceallevel==0
        set conceallevel=2
    else
        set conceallevel=0
    endif
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Toggles
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" => Toggle Functionality
""""""""""""""""""""""""""""""
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

" Penci:
noremap <leader>Tp :TogglePencil<cr>
let g:which_key_map.T.p = '[t]oggle [p]encil'


""""""""""""""""""""""""""""""
" => Toggle User Interface
""""""""""""""""""""""""""""""

let g:which_key_map.t = { 'name': '+UI-Toggle' }

" Tagbar:
noremap <leader>tt :TagbarToggle<cr>
let g:which_key_map.t.t = '[t]oggle [t]agbar'
" NERDTree:
nnoremap <leader>tf :NERDTreeMirror<cr>:NERDTreeToggle<cr>
let g:which_key_map.t.f = '[t]oggle [f]iletree'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual Mode
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


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
" => Parenthesis/bracket
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

vnoremap $1 <esc>`>a)<esc>`<i(<esc>
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $e <esc>`>a`<esc>`<i`<esc>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Extra mappings: [v]im
let g:which_key_map.v = { 'name': '+vim' }
nnoremap <leader>vs :source ~/.config/vim/vimrc<cr>
let g:which_key_map.v.s = '[v]im [s]ource vimrc'
nnoremap <leader>vu :DeinUpdate<cr>
let g:which_key_map.v.u = '[v]im [u]pdate plugins'

" Extra mappings: [o]pen
noremap <C-P> :NERDTreeClose\|CtrlP<cr>
let g:which_key_map.o = { 'name': '+open' }
noremap <leader>of :NERDTreeClose\|CtrlP<cr>
let g:which_key_map.o.f = '[o]pen [f]ile'
noremap <leader>ob :NERDTreeClose\|CtrlPBuffer<cr>
let g:which_key_map.o.b = '[o]pen [b]uffer'
noremap <leader>or :NERDTreeClose\|CtrlPMRU<cr>
let g:which_key_map.o.r = '[o]pen [r]ecent'

" Extra mappings: [p]aste
nnoremap <leader>p <Plug>yankstack_substitute_older_paste
nnoremap <leader>P <Plug>yankstack_substitute_newer_paste

" Extra mappings: [c]omment
let g:tcomment_maps = 0
"nmap <silent><leader>c <Plug>TComment_gc
nnoremap <silent><leader>cc <Plug>TComment_gcc
nnoremap <silent><leader>c< <Plug>TComment_Uncomment
nnoremap <silent><leader>c<c <Plug>TComment_Uncommentc
nnoremap <silent><leader>c<b <Plug>TComment_Uncommentb
nnoremap <silent><leader>c> <Plug>TComment_Comment
nnoremap <silent><leader>c>c <Plug>TComment_Commentc
nnoremap <silent><leader>c>b <Plug>TComment_Commentb
let g:which_key_map.c = {
            \ 'name': '+comment',
            \ 'cc': 'toggle comment for current line',
            \ 'c<': 'uncomment region',
            \ 'c<c': 'uncomment current line',
            \ 'c<b': 'uncomment region as block',
            \ 'c>': 'comment region',
            \ 'c>c': 'comment current line',
            \ 'c>b': 'comment region as block',
            \ }


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

