""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BasedOn:
"       The Ultimate VIM Configuration
"           https://github.com/amix/vimrc
"
" Sections:
"    -> Options
"    -> Files, backups and undo
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

set ffs=unix,dos,mac	" Use Unix as the standard file type
"set autochdir 		" Set working directory
" Tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
" Buffer
set switchbuf=useopen,usetab,newtab
set showtabline=2
" Wrapping
set autoindent 		" Auto indent
set smartindent 	" Smart indent
set wrap 	    	" Wrap lines
" Cursor
set scrolloff=7      " Leave 7 lines around the cursor when moving vertically using j/k
set sidescrolloff=10 " Leave 10 characters around the cursor when moving horizontally using h/l
set ruler            " Always show current position
set mat=2            " How many tenths of a second to blink when matching brackets
set showmatch        " Show matching brackets when text indicator is over them
set concealcursor=c
set conceallevel=2
" Searching
set ignorecase       " Ignore case when searching
set smartcase        " When searching try to be smart about cases
set hlsearch         " Highlight search results
set incsearch        " Makes search act like search in modern browsers
set wrapscan         " Searches wrap around the end of the file
" Layout
set cmdheight=2      " Height of the command bar
set foldcolumn=0     " Add a bit extra margin to the left
set mouse=nv         " Disable mouse in command-line mode
set number           " Enable line-numbering
" Completion
set wildmenu         " Turn on the Wild menu
set magic            " For regular expressions turn magic on
" Performance
set lazyredraw       " Don't redraw while executing macros (good performance config)
set synmaxcol=2500   " Don't syntax highlight long lines
" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
" No beep
set noerrorbells
set novisualbell
set t_vb=
"set tm=500
" Misc
set report=2         " Report on line changes
set formatoptions+=1 " Don't break lines after a one-letter word
set hidden           " Allow changed buffers to be hidden
set history=500      " Sets how many lines of history VIM has to remember

" What to save for views and sessions:
set viewoptions=folds,cursor,curdir,slash,unix
set sessionoptions=curdir,help,tabpages,winsize

" Wildmenu: Ignore compiled files
if has('wildmenu')
	if ! has('nvim')
		set nowildmenu
		set wildmode=list:longest,full
	endif
	set wildignorecase
	set wildignore+=.git,.hg,.svn,.stversions,*.pyc,*.spl,*.o,*.out,*~,%*
	set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
	set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*
	set wildignore+=__pycache__,*.egg-info,.pytest_cache,.mypy_cache/**
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable undo and swap
set undofile swapfile

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
set viminfo+=n~/.local/share/vim/viminfo

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

