""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer:
"       Kevin Witlox - @quitlox
"
" Description:
"       This file contains the configuration of all plugins specified in vimrc.
"       Where possible, plugins are by default minimally configured. The
"       rationale is that most plugins have proper defaults, and including
"       intens opinionated configuration out-of-the-box is incomprehensive
"       and counter-productive to the user.
"
" Plugins:
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => User Interface
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Vim Airline:
" Next to statusline, also enable tabline
let g:airline#extensions#tabline#enabled = 1
" Format to use when displaying file name in tabline
let g:airline#extensions#tabline#formatter = 'unique_tail'
" Theming
let g:airline_theme = 'base16_vim'
let g:airline_powerline_fonts = 1


" NERDTree:
let NERDTreeShowHidden=1
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif


" CtrlP:
" Disable default mapping
let g:ctrlp_map = ''
" Ignore certain files in result
let g:ctrlp_custom_ignore = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee'
" List results top-to-bottom
let g:ctrlp_match_window = 'order:ttb'
" Scan for hidden files and directories
let g:ctrlp_show_hidden = 1
" Make new files replace the current window
let g:ctrlp_open_new_file = 'r'


" VimWhichKey:
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
            \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
let g:which_key_use_floating_win = 0


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim Operations
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Sneak:
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

autocmd User SneakLeave highlight clear Sneak
"highlight Sneak gui=bold guifg=black guibg=yellow ctermfg=black ctermbg=yellow

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Rainbow Parentheses Improved:
let g:rainbow_active = 1
let g:rainbow_conf = {
            \ 'separately': {
                \ 'djangohtml': 0
            \}
        \ }


" pencil:
let g:pencil#autoformat = 0
let g:pencil#wrapmodedefault = 'soft'
let g:pencil#textwidth = 80
let g:airline_section_x = '%{PencilMode()}'

" Markdown:
" Open Markdown file without folding
let g:vim_markdown_folding_disabled = 1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Language Support
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugin: coc.vim
let g:coc_global_extensions = [
            \ 'coc-bootstrap-classname',
            \ 'coc-css', 'coc-eslint', 'coc-git',
            \ 'coc-html',
            \ 'coc-htmldjango', 'coc-html-css-support',
            \ 'coc-json', 'coc-markdownlint',
            \ 'coc-marketplace', 'coc-prettier',
            \ 'coc-pyright', 'coc-pydocstring',
            \ 'coc-rls', 'coc-rust-analyzer', 'coc-sh',
            \ 'coc-tailwindcss', 'coc-tsserver',
            \ 'coc-toml', 'coc-vimlsp', 'coc-vimtex',
            \ 'coc-yaml',
            \ 'coc-yank', 'coc-xml'
            \]

" Plugin: vimtex
let g:vimtex_compiler_method = 'tectonic'
let g:vimtex_quickfix_method = 'pplatex'
let g:vimtex_view_method = 'zathura'

