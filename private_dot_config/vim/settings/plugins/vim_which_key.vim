
"#######################################
"### SETTINGS                        ###
"#######################################

let g:which_key_use_floating_win = 1

"#######################################
"### BEHAVIOUR                       ###
"#######################################

autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
            \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
