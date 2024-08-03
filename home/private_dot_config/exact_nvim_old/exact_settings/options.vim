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

" Automatically resize Windows when resizing the terminal
 autocmd VimResized * wincmd =
 autocmd TermOpen * wincmd =
" autocmd WinEnter * wincmd =
" autocmd WinLeave * wincmd =
set equalalways
set ead=hor

" Set quickfix buffers as unlisted
augroup HideQuickFix
    autocmd!
    autocmd FileType qf set nobuflisted
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Options [Vim Compatibility]
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" The following options are defaults in neovim, but need to be set in vim to
" make it behave sanely

if &compatible
  set nocompatible " Be iMproved
endif

set t_vb=                                       " No audible bell in TUI mode
set backspace=eol,start,indent                  " Make backspace behave sanely
set formatoptions=tcqj				" defaults
set formatoptions+=vj                           " join commented lines properly
" set formatoptions-=t                            " do not auto-wrap text using textwidth
set formatoptions+=c                            " do auto-wrap comments using textwidth
set formatoptions+=r				" continue comments when pressing enter in insert mode
set formatoptions+=1				" do not break lines after a one-letter word
set formatoptions+=p				" do not break lines after a period
set wildmenu                                    " specifies how command line completion works
set magic                                       " will break plugins if off
set viewoptions=folds,cursor,curdir,slash,unix  " list of words that specifies what to save for :mkview
set sessionoptions+=winpos,terminal,folds       " list of words that specifies what to put in a session file

" Sane Defaults that Neovim already sets but Vim doesn't
if has('vim-9.0.0667')
    set splitkeep=screen " Not in stable yet currently?
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set ffs=unix,dos,mac	" Use Unix as the standard file type
" Buffer
set hidden              " Allow changed buffers to be hidden
set switchbuf=uselast
" Comments
set comments+=:#
" Editing Defaults
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
" Wrapping
set autoindent
set nosmartindent    " This causes comments not to be moved while indenting
set nocindent        " This causes comments to wrap weirdly with parenthesis
set autoindent	     " This is the modern way, which fixes the above
set nowrap
set linebreak
" Cursor
set scrolloff=7      " Leave 7 lines around the cursor when moving vertically using j/k
set sidescrolloff=10 " Leave 10 characters around the cursor when moving horizontally using h/l
set ruler            " Always show current position
set mat=2            " How many tenths of a second to blink when matching brackets
set showmatch        " Show matching brackets when text indicator is over them
set cursorline
set culopt=number
set concealcursor=c
" set conceallevel=2
" Searching
set ignorecase
set smartcase
set hlsearch
set incsearch
set wrapscan
" Layout
set signcolumn=yes   " Prevent the error gutter from moving the vertical seperator
set mouse=nv         " Disable mouse in command-line mode
set number           " Enable line-numbering
set showtabline=2
set splitright	     " Open splits in the window to the right
set splitbelow       " Like vscode
set splitkeep=screen
" Performance
set lazyredraw       " Don't redraw while executing macros (good performance config)
" Configure backspace so it acts as it should act
set whichwrap+=<,>,h,l
" No beep
set noerrorbells
set novisualbell
" Misc
set confirm
set fillchars+=eob:\ ,
set formatoptions+=1 " Don't break lines after a one-letter word
set history=1000      " Sets how many lines of history VIM has to remember
set title
set titlestring=neovim:\ %{fnamemodify(getcwd(),':t')}\ \(%t\) titlelen=70
set timeoutlen=800

let g:loaded_python_provider = 0
let g:python3_host_prog = '/usr/bin/python3'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Spell check
set spell
set spelllang=en_us
