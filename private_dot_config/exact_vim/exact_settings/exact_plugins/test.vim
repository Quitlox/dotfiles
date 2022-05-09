
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

" VIM: WhichKey
if !has('nvim')
  nmap <silent> <localleader>Tt :TestFile<cr>
  nmap <silent> <localleader>Ta :TestSuite<cr>

  let g:which_key_local_map.T = {'name': '+Test'}
  let g:which_key_local_map.T.t = '[T]est file'
  let g:which_key_local_map.T.a = '[T]est [a]ll'
else

" NEOVIM: WhichKey
lua << EOF
local wk = require("which-key")
wk.register({
  ["<localleader>"] = {
    T = {
      name = "Test",
      t = "[T]est file",
      a = "[T]est [a]ll",
    },
  },
})
EOF
endif
