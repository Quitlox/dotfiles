
" FILE Configi3:
" Syntax Highlighting for i3 config
aug i3config_ft_detection
  au!
  au BufNewFile,BufRead ~/.config/i3/config set filetype=i3config
aug end

" FILE Polybar:
aug polybar_ft_detection
  au!
  au BufNewFile,BufRead ~/.config/polybar/config set filetype=dosini
aug end

" LANG Vim:
au FileType vim let b:delimitMate_matchpairs = "(:),[:],{:},<:>"

" LANG Tex:
au FileType tex let b:delimitMate_matchpairs = "[:],{:},<:>"
au FileType tex syntax match texMathSymbol '\\bra{\%([^{]*{[^}]*}[^}]*}\|[^}]*}\)\@=' contained conceal cchar=<
au FileType tex syntax match texMathSymbol '\%(\\bra{[^{]*{[^}]*}[^}]*}\|[^}]*\)\@<=}' contained conceal cchar=|
au FileType tex syntax match texMathSymbol '\\ket{\%([^{]*{[^}]*}[^}]*}\|[^}]*}\)\@=' contained conceal cchar=|
au FileType tex syntax match texMathSymbol '\%(\\ket{[^{]*{[^}]*}[^}]*}\|[^}]*\)\@<=}' contained conceal cchar=>
"au FileType tex syntax match texMathSymbol /\\braket{\%([^{]*{[^}]*}[^}]*}\|[^}]*}\)\@=/ contained conceal cchar=<
"au FileType tex syntax match texMathSymbol /\%(\\braket{[^{]*{[^}]*}[^}]*}\|[^}]*\)\@<=}/ contained conceal cchar=>

" LANG Python:
autocmd Filetype python nnoremap <F12> <Esc>:REPLDebugStopAtCurrentLine<Cr>
autocmd Filetype python nnoremap <F10> <Esc>:REPLPDBN<Cr>
autocmd Filetype python nnoremap <F11> <Esc>:REPLPDBS<Cr>

" FILE VsCode:
aug vscode_ft_detection
  au!
  au BufNewFile,BufRead ~/.config/Code/User/settings.json set filetype=jsonc
aug end

" FILE SageMath
augroup filetypedetect
  au! BufRead,BufNewFile *.sage,*.spyx,*.pyx setfiletype python
augroup END
