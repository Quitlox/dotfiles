
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable undo and swap
set undofile swapfile 

if !has('nvim')

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

