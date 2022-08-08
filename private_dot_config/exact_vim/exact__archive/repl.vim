if has('nvim') | finish | endif

"#######################################
"### VIM-REPL Plugin                 ###
"#######################################

""""""""""""""""""""""""""""""""""""""""
" => Settings
""""""""""""""""""""""""""""""""""""""""

" let g:repl_python_pre_launch_command='[[ -d .env ]] && source .env/bin/activate'
" let g:repl_python_pre_launch_command.=' || [[ -d .venv ]] && source .venv/bin/activate'
" let g:repl_python_pre_launch_command.=' || [[ -d venv ]] && source venv/bin/activate'

let g:repl_program = {
            \   'python': 'ipython',
            \   'default': 'zsh',
            \   'vim': 'vim -e',
            \   }
let g:repl_predefine_python = {
            \   'numpy': 'import numpy as np',
            \   'matplotlib': 'from matplotlib import pyplot as plt'
            \   }
let g:repl_exit_commands = {
			\	'python': 'quit()',
			\	'ipython': 'quit()',
			\	'bash': 'exit',
			\	'zsh': 'exit',
			\	'default': 'exit',
			\	}
" If not set, the version is determined dynamically, causing lag
let g:repl_ipython_version = '7.7'

let g:repl_output_copy_to_register = "o"
" Auto-merge multiline code before sending
let g:repl_python_automerge = 1
" Default REPL position (0 = bottom, 3 = right)
let g:repl_position=0
" Whether the cursor automatically moves down after sending code to REPL
let g:repl_cursor_down = 0
" Let cursor stay at REPL on REPLToggle
let g:repl_stayatrepl_when_open = 1
" Name of REPL buffer
let g:repl_console_name = 'ZYTREPL'

""""""""""""""""""""""""""""""""""""""""
" => Keybindings
""""""""""""""""""""""""""""""""""""""""

let g:sendtorepl_invoke_key = "<localleader>rl"

nnoremap <localleader>rr :REPLToggle<Cr>
nnoremap <localleader>rb :REPLSendSession<Cr>

autocmd Filetype python nnoremap <F12> <Esc>:REPLDebugStopAtCurrentLine<Cr>
autocmd Filetype python nnoremap <F10> <Esc>:REPLPDBN<Cr>
autocmd Filetype python nnoremap <F11> <Esc>:REPLPDBS<Cr>

let g:which_key_local_map.r = { 'name': '+open' }
let g:which_key_local_map.r.f = '[r]epl toggle'
let g:which_key_local_map.r.b = '[r]epl send code [b]lock'
let g:which_key_local_map.r.l = '[r]epl send [l]ine'
