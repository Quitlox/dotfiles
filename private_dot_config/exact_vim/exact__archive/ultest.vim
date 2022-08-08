
" For clarification, this file contains the configuration
" for both the vim-ultest and vim-test plugins. The latter is
" the heart and sole, the former is the convenience wrapper.

"#######################################
"### VIM-ULTEST                      ###
"#######################################

" Navigate failed tests
nmap ]t <Plug>(ultest-next-fail)
nmap [t <Plug>(ultest-prev-fail)

"#######################################
"### VIM-TEST                        ###
"#######################################

nmap <silent> <localleader>tt :UltestNearest<cr>
nmap <silent> <localleader>tf :Ultest<cr>
nmap <silent> <localleader>ta :Ultest<cr>

" VIM: WhichKey
if !has('nvim')
  let g:which_key_local_map.t = {'name': '+test'}
  let g:which_key_local_map.t.t = '[T]est nearest'
  let g:which_key_local_map.t.f = '[T]est [f]ile'
  let g:which_key_local_map.t.a = '[T]est [a]ll'
else

" NEOVIM: WhichKey
lua << EOF
local wk = require("which-key")
wk.register({
  ["<localleader>"] = {
    t = {
      name = "test",
      t = "[t]est nearest",
      f = "[t]est [f]ile",
      a = "[t]est [a]ll",
    },
  },
})
EOF
endif
