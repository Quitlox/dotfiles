""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BasedOn:
"		The Ultimate VIM Configuration
"			https://github.com/amix/vimrc
"
" Sections:
"    -> Options [Vim Compatibility]
"    -> Options
"    -> Files, backups and undo
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" Highlight lua in viml
let g:vimsyn_embed = 'l'

" Never insert comments when pressing o or O
" The standard ftplugin usually overwrite this,
" so it has to be an autocmd.
autocmd FileType * setlocal formatoptions-=o

" Remove some default mappings that conflict
map K <Nop>
map [f <Nop>
map ]f <Nop>

" Enable fold using treesitter
" TODO: Deprecated by ufo fold?
" if has('nvim')
"     set foldmethod=expr
"     set foldexpr=nvim_treesitter#foldexpr()
" end

" Automatically resize Windows when resizing the terminal
autocmd VimResized * wincmd =

" Set quickfix buffers as unlisted
augroup HideQuickFix
    autocmd!
    autocmd FileType qf set nobuflisted
augroup END

" Delete all non-visible buffers
func BufOnly()
    " Gather all listed buffers
    let buflist = []
    for i in range(tabpagenr('$'))
        call extend(buflist, tabpagebuflist(i + 1))
    endfor

    " Close all unmodified listed buffers
    let count = 0
    let l:blist = getbufinfo()
    for l:item in l:blist
        if index(buflist, l:item.bufnr) == -1 && l:item.listed && !l:item.changed
            let count = count + 1
            exe 'bd ' . l:item.bufnr
        endif
    endfor

    if count > 0
        echo 'Deleted ' . count . ' buffers!'
    endif
endfunc
:command BufOnly :call BufOnly()

" Delete all junk buffers
func BufJunk()
    " All existing buffers
    let l:blist = getbufinfo()
    for l:item in l:blist
        if l:item.linecount == 1 
            echo 'Deleting ' . l:item.bufnr
            exe 'bwipeout ' . l:item.bufnr
        endif
    endfor
endfunc
:command BufJunk :call BufJunk()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Options [Vim Compatibility]
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" The following options are defaults in neovim, but need to be set in vim to
" make it behave sanely

if &compatible
  set nocompatible " Be iMproved
endif

" No audible bell in TUI mode
set t_vb=
" Make backspace behave sanely
set backspace=eol,start,indent
" Join commented lines properly
set formatoptions=vtj
" Completion
set wildmenu
" Will break plugins if off
set magic
" What to save for views and sessions:
set viewoptions=folds,cursor,curdir,slash,unix
set sessionoptions+=winpos,terminal,folds

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set ffs=unix,dos,mac	" Use Unix as the standard file type
" Tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
" Buffer
set hidden           " Allow changed buffers to be hidden
" Wrapping
set autoindent 		" Auto indent
set smartindent 	" Smart indent
set nowrap 	    	" Wrap lines
set linebreak		" Wrap lines at full words
set nofoldenable	" Disable folding
set textwidth=80
" Cursor
set scrolloff=7      " Leave 7 lines around the cursor when moving vertically using j/k
set sidescrolloff=10 " Leave 10 characters around the cursor when moving horizontally using h/l
set ruler            " Always show current position
set mat=2            " How many tenths of a second to blink when matching brackets
set showmatch        " Show matching brackets when text indicator is over them
set cursorline
set culopt=number
set concealcursor=c
set conceallevel=2
" Searching
set ignorecase       " Ignore case when searching
set smartcase        " When searching try to be smart about cases
set hlsearch         " Highlight search results
set incsearch        " Makes search act like search in modern browsers
set wrapscan         " Searches wrap around the end of the file
" Layout
set signcolumn=yes     " Prevent the error gutter from moving the vertical seperator
set mouse=nv         " Disable mouse in command-line mode
set number           " Enable line-numbering
set showtabline=2
set splitright		 " Open splits in the window to the right
					 " For opening splits from NERDTree
set splitbelow       " Like vscode
" Performance
set lazyredraw       " Don't redraw while executing macros (good performance config)
" Configure backspace so it acts as it should act
set whichwrap+=<,>,h,l
" No beep
set noerrorbells
set novisualbell
" Misc
set formatoptions+=1 " Don't break lines after a one-letter word
set timeoutlen=800
set history=1000      " Sets how many lines of history VIM has to remember

" Sane Defaults that Neovim already sets but Vim doesn't
if has('vim-9.0.0667')
    set splitkeep=screen " Not in stable yet currently?
endif

if has('nvim')
	let g:loaded_python_provider = 0
	let g:python3_host_prog = '/usr/bin/python3'

    " Buffer
    set switchbuf=uselast
    " Spell check
    set spell
    set spelllang=en_us
    " augroup CustomEnableSpell
    "     autocmd!
    "     autocmd FileType markdown,txt setlocal spell
    "     autocmd FileType markdown,txt setlocal spelllang=en_us
    " augroup END

    " Disable spell for certain buffers
    augroup CustomDisableSpell
        autocmd!
        autocmd FileType checkhealth setlocal nospell
        autocmd FileType NeogitStatus setlocal nospell
        autocmd FileType dap-repl setlocal nospell
        autocmd FileType dapui_* setlocal nospell
        autocmd FileType Outline setlocal nospell
        autocmd TermOpen * setlocal nospell
    augroup END
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable Functionality
set undofile swapfile backup

"Make backup before overwriting the current buffer
set backupcopy=yes

"Meaningful backup name, ex: filename@2015-04-05.14:59
au BufWritePre * let &bex = '@' . strftime("%F.%H:%M")

if has('nvim')
    " Configure vim directories
    let xdg_cache=$XDG_CACHE_HOME
    let xdg_data=$XDG_DATA_HOME
    let xdg_config=$XDG_CONFIG_HOME

    if empty(xdg_cache)
        let xdg_cache=$HOME . '/.cache'
    endif
    if empty(xdg_data)
        let xdg_data=$HOME . '/.local/share'
    endif
    if empty(xdg_config)
        let xdg_config=$HOME . '/.config'
    endif

    " Update runtimepath
    exe 'set rtp^=' . xdg_config . '/nvim'
    exe 'set rtp+=' . xdg_data . '/nvim'
    exe 'set rtp+=' . xdg_config . '/nvim/after'

    " Set directory locations
    let g:netrw_home = xdg_data . '/nvim'
    let &viewdir=xdg_data . '/nvim/view'
    let &backupdir=xdg_cache . '/nvim/backup'
    let &directory=xdg_cache . '/nvim/swap'
    let &undodir=xdg_cache . '/nvim/undo'
else
    " Configure vim directories
    let xdg_cache=$XDG_CACHE_HOME
    let xdg_data=$XDG_DATA_HOME
    let xdg_config=$XDG_CONFIG_HOME

    if empty(xdg_cache)
        let xdg_cache=$HOME . '/.cache'
    endif
    if empty(xdg_data)
        let xdg_data=$HOME . '/.local/share'
    endif
    if empty(xdg_config)
        let xdg_config=$HOME . '/.config'
    endif

    " Update runtimepath
    exe 'set rtp^=' . xdg_config . '/vim'
    exe 'set rtp+=' . xdg_data . '/vim'
    exe 'set rtp+=' . xdg_config . '/vim/after'

    " Set directory locations
    let g:netrw_home = xdg_data . '/vim'
    let &viewdir=xdg_data . '/vim/view'
    let &backupdir=xdg_cache . '/vim/backup'
    let &directory=xdg_cache . '/vim/swap'
    let &undodir=xdg_cache . '/vim/undo'
endif


if !has('nvim')
    set viminfo+=n~/.local/share/vim/viminfo
endif

" Disable undo on tmp files
augroup user_persistent_undo
	autocmd!
	au BufWritePre /tmp/*          setlocal noundofile
	au BufWritePre COMMIT_EDITMSG  setlocal noundofile
	au BufWritePre MERGE_MSG       setlocal noundofile
	au BufWritePre *.tmp           setlocal noundofile
	au BufWritePre *.bak           setlocal noundofile
augroup END

" If sudo, disable vim swap/backup/undo/shada/viminfo writing
if $SUDO_USER !=# '' && $USER !=# $SUDO_USER
		\ && $HOME !=# expand('~'.$USER, 1)
		\ && $HOME ==# expand('~'.$SUDO_USER, 1)

	set noswapfile
	set nobackup
	set nowritebackup
	set noundofile
	if has('nvim')
		set shada="NONE"
	else
		set viminfo="NONE"
	endif
endif
