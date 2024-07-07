if &term != 'urxvt' | finish | endif
echo "Loaded urxvt configuration"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Key Bindings                                        """
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GENERAL REMARK: URxvt uses different escape sequence when
" compared to xterm, which can cause issues as vim seems to
" be oriented towards xterm.
" This means that URxvt users have to do a bit more work to
" get their vim working as expected.
" As a URxvt user, you have to options:
"   1) Configure VIM: Map special key sequences to the URxvt
"      escape sequences.
"   2) Configure URxvt: Map special key sequences to
"      different escape sequences (e.g. to those of xterm)
"      (see: http://www.netswarm.net/misc/urxvt-xtermcompat.txt)


" Workaround to make Alt key mappings (<M-X>) work in URxvt.
" Alternatively map directly on the correct escape sequence:
"   e.g. for <M-j> use '<Esc>j'
if stridx($TERM, 'rxvt') >= 0
    execute "set <M-j>=\ej"
    execute "set <M-k>=\ek"
endif


