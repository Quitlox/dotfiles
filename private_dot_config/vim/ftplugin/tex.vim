au FileType tex let b:delimitMate_matchpairs = "[:],{:},<:>"
au FileType tex syntax match texMathSymbol '\\bra{\%([^{]*{[^}]*}[^}]*}\|[^}]*}\)\@=' contained conceal cchar=<
au FileType tex syntax match texMathSymbol '\%(\\bra{[^{]*{[^}]*}[^}]*}\|[^}]*\)\@<=}' contained conceal cchar=|
au FileType tex syntax match texMathSymbol '\\ket{\%([^{]*{[^}]*}[^}]*}\|[^}]*}\)\@=' contained conceal cchar=|
au FileType tex syntax match texMathSymbol '\%(\\ket{[^{]*{[^}]*}[^}]*}\|[^}]*\)\@<=}' contained conceal cchar=>
au FileType tex syntax match texMathSymbol /\\braket{\%([^{]*{[^}]*}[^}]*}\|[^}]*}\)\@=/ contained conceal cchar=<
au FileType tex syntax match texMathSymbol /\%(\\braket{[^{]*{[^}]*}[^}]*}\|[^}]*\)\@<=}/ contained conceal cchar=>
