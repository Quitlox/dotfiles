" NOTE: The Neovim indent-blankline plugin also reads and uses these options

" Neovim-only features
let g:indent_blankline_use_treesitter=v:true
let g:indent_blankline_show_current_context=v:true
let g:indent_blankline_show_current_context_start=v:false

let g:indent_blankline_show_end_of_line=v:false

" Don't show the indentLines in the WhichKey floating window
let g:indentLine_fileTypeExclude=['WhichKey', 'WhichKeyFloat']

