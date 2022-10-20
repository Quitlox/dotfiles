"#######################################
"### Clever                          ###
"#######################################

let g:clever_f_smart_case=1

if (!has('nvim') && dein#is_available(['clever-f.vim'])) || has('nvim')
    map ; <Plug>(clever-f-repeat-forward)
    map , <Plug>(clever-f-repeat-back)
end


if has('nvim')
    let g:clever_f_mark_char_color="HopNextKey"
else
    " Doesn't work? :c
    " let g:clever_f_mark_char_color="EasyMotionShade"
end
