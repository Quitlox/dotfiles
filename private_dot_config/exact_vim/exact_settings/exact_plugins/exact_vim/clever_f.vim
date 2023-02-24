"#######################################
"### Clever                          ###
"#######################################

let g:clever_f_smart_case=1

if dein#is_available(['clever-f.vim'])
    map ; <Plug>(clever-f-repeat-forward)
    map , <Plug>(clever-f-repeat-back)
end


if has('nvim')
    let g:clever_f_mark_char_color="HopNextKey"
else
    " Doesn't work? :c
    " let g:clever_f_mark_char_color="EasyMotionShade"
end
