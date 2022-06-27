
let g:strip_whitespace_confirm=0

" EnableStripWhitespaceOnSave for .tex
autocmd FileType tex EnableStripWhitespaceOnSave

" Disable showing
let g:better_whitespace_filetypes_blacklist=['tex',
      \ 'diff', 'git', 'gitcommit', 'unite', 'qf', 'help', 'markdown', 'fugitive']
