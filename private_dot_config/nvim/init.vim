""""""""""""""""""""""""""""""""""""""""
""" PLUGIN MANAGER
""""""""""""""""""""""""""""""""""""""""

call plug#begin()
" Defaults everyone can agree on
Plug 'tpope/vim-sensible'
call plug#end()

if has("nvim")
	Plug 'neo
end
