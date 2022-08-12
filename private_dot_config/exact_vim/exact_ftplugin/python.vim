autocmd Filetype python nnoremap <F12> <Esc>:REPLDebugStopAtCurrentLine<Cr>
autocmd Filetype python nnoremap <F10> <Esc>:REPLPDBN<Cr>
autocmd Filetype python nnoremap <F11> <Esc>:REPLPDBS<Cr>
"
" lua << EOF
" wk.register({
"   g = {
"     o = { ":call CocAction('runCommand', 'python.sortImports')<cr>", "organise imports" },
"   },
" })
" EOF
