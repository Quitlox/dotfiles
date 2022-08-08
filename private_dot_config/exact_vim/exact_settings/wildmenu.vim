
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
	" Version Control
	set wildignore+=.git,.hg,.svn,.stversions,*.spl,
	" Temp files
	set wildignore+=*.o,*.out,*~,%*,Session.vim,
	" Misc. files
	set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
	" Web Dev
	set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*,*.lock
	" Python
	set wildignore+=__pycache__,*.egg-info,.pytest_cache,.mypy_cache/**,*.pyc,
	" Latex
	set wildignore+=*.aux,*.bbl,*.bcf,*.blg,*.fls,*.log,*.run*.xml,*.synctex*.gz,*.fdb_latexmk,*.glg,*.glo,*.gls,*.ist,*.toc,*.glsdefs,*.tikzstyles
endif


