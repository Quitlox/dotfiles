if !(dein#is_available(['nerdtree'])) | finish | endif

"#######################################
"### SETTINGS                        ###
"#######################################

let NERDTreeShowHidden=1
let g:NERDTreeWinSize=35
let g:NERDTreeHighlightCursorline=0
let g:NERDTreeAutoDeleteBuffer=1
let g:NERDTreeCustomOpenArgs={
      \ 'file': {
        \ 'reuse': 'currenttab',
        \ 'where': 'p'
      \ },
      \ 'dir': {}
      \ }

" Ignore using Wildignore
let g:NERDTreeRespectWildIgnore=1

"#######################################
"### Interface                       ###
"#######################################

" Fix padding issue: https://github.com/ryanoasis/vim-devicons/issues/248
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ""
let g:WebDevIconsUnicodeDecorateFolderNodes = v:true
" Disable arrow icons at the left side of folders for NERDTree.
"let g:NERDTreeDirArrowExpandable = "\u00a0"
"let g:NERDTreeDirArrowCollapsible = "\u00a0"
autocmd FileType nerdtree setlocal signcolumn=no
" Make DeviCons and GitStatus behave
let g:NERDTreeGitStatusConcealBrackets = 0
let g:NERDTreeGitStatusUseNerdFonts = 1

"#######################################
"### Keybindings                     ###
"#######################################

let g:NERDTreeMapOpenSplit='v'
let g:NERDTreeMapPreviewSplit='gv'
let g:NERDTreeMapOpenVSplit='b'
let g:NERDTreeMapPreviewVSplit='gb'

"#######################################
"### CUSTOM                          ###
"#######################################

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree')
      \ && b:NERDTree.isTabTree() |
      \ quit | endif
