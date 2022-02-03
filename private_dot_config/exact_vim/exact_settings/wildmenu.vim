
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Wildmenu
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Wildmenu: Ignore compiled files
if has('wildmenu')
	if ! has('nvim')
		set nowildmenu
		set wildmode=list:longest,full
	endif
	set wildignorecase
	set wildignore+=.git,.hg,.svn,.stversions,*.pyc,*.spl,*.o,*.out,*~,%*
	set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
	set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*,*.lock
	set wildignore+=__pycache__,*.egg-info,.pytest_cache,.mypy_cache/**
endif


