""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OriginalMaintainer:
"       Amir Salihefendic — @amix3k
"
" BasedOn:
"       The Ultimate VIM Configuration
"           https://github.com/amix/vimrc
"
" Sections:
"    -> General
"    -> Editor
"    -> GUI related
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Moving around, tabs and buffers
"    -> Status line
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Misc
"    -> Helper functions
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editor
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"set autochdir 		" Set working directory
" Tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
" Cursor
set scrolloff=7		        " Leave 7 lines around the cursor when moving vertically using j/k
set sidescrolloff=10 " Leave 10 characters around the cursor when moving horizontally using h/l
set ruler		        " Always show current position
set mat=2		        " How many tenths of a second to blink when matching brackets
set showmatch 		    " Show matching brackets when text indicator is over them
set concealcursor=nc
set conceallevel=2
" Searching
set ignorecase		    " Ignore case when searching
set smartcase   		" When searching try to be smart about cases
set hlsearch    		" Highlight search results
set incsearch   		" Makes search act like search in modern browsers
set wrapscan    		" Searches wrap around the end of the file
" Layout
set cmdheight=2	    	" Height of the command bar
set foldcolumn=0    	" Add a bit extra margin to the left
set mouse=nv	    	" Disable mouse in command-line mode
set number              " Enable line-numbering
" Completion
set wildmenu	    	" Turn on the Wild menu
set magic		        " For regular expressions turn magic on
" Performance
set lazyredraw 	    	" Don't redraw while executing macros (good performance config)
set synmaxcol=2500	    " Don't syntax highlight long lines
" Misc
"DEL set hid 		        " A buffer becomes hidden when it is abandoned
set report=2		    " Report on line changes
set formatoptions+=1	" Don't break lines after a one-letter word
set hidden						" Allow changed buffers to be hidden

" CoC:
" Encoding
set encoding=utf-8
" Performance
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

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

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" No beep (vim)
set noerrorbells
set novisualbell
set t_vb=
set tm=500

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => GUI related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set font according to system
if has("mac") || has("macunix")
    set gfn=IBM\ Plex\ Mono:h14,Hack:h14,Source\ Code\ Pro:h15,Menlo:h15
elseif has("win16") || has("win32")
    set gfn=IBM\ Plex\ Mono:h14,Source\ Code\ Pro:h12,Bitstream\ Vera\ Sans\ Mono:h11
elseif has("gui_gtk2")
    set gfn=IBM\ Plex\ Mono\ 14,:Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("linux")
    set gfn=IBM\ Plex\ Mono\ 14,:Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("unix")
    set gfn=Monospace\ 11
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Syntax highlighting
"DEL syntax enable 		    " Enable syntax highlighting
" Encoding
set encoding=utf8	    " Set utf8 as standard encoding and en_US as the standard language
set ffs=unix,dos,mac	" Use Unix as the standard file type


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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use space instead of tab
"DEL set expandtab		" Use spaces instead of tabs
"DEL set smarttab		" Be smart when using tabs ;)
"DEL set shiftwidth=4
"DEL set tabstop=4
"DEL set softtabstop=4

set autoindent 		" Auto indent
set smartindent 	" Smart indent
set wrap 	    	" Wrap lines

" Linebreak on 500 characters
set linebreak
set tw=500


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Automatic functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Can probably be deleted due to Sleuth.vim
if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

