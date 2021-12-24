if !(dein#is_available(['preservim/nerdtree'])) | finish | endif

"#######################################
"### SETTINGS                        ###
"#######################################

let NERDTreeShowHidden=1
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let g:NERDTreeWinSize=35

"#######################################
"### CUSTOM                          ###
"#######################################

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree')
      \ && b:NERDTree.isTabTree() |
      \ quit | endif

