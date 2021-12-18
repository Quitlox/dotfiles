"#######################################
"### SETTINGS                        ###
"#######################################

" Encoding
set encoding=utf-8
" Performance
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c


let g:coc_config_home = '~/.config/vim'
let g:coc_global_extensions = [
            \ 'coc-bootstrap-classname',
            \ 'coc-css', 'coc-eslint', 'coc-git',
            \ 'coc-html',
            \ 'coc-htmldjango', 'coc-html-css-support',
            \ 'coc-json', 'coc-markdownlint',
            \ 'coc-marketplace', 'coc-prettier',
            \ 'coc-pyright', 'coc-pydocstring',
            \ 'coc-rls', 'coc-rust-analyzer', 'coc-sh',
            \ 'coc-snippets',
            \ 'coc-tailwindcss', 'coc-tsserver',
            \ 'coc-toml', 'coc-vimlsp', 'coc-vimtex',
            \ 'coc-yaml',
            \ 'coc-yank', 'coc-xml'
            \]

"#######################################
"### COMPLETION                      ###
"#######################################

"### BACKSPACE #########################
" Abort on Backspace
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

"### NAVIGATE COMPLETION ###############
" Navigate completion list backward with <S-Tab>
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" Confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

"### TRIGGER ###########################
" Trigger Autocomplete with <C-Space>
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

"#######################################
"### KEYBINDINGS                     ###
"#######################################

nmap <silent> [e <Plug>(coc-diagnostic-prev)
nmap <silent> ]e <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gu <Plug>(coc-references)
nmap <silent> gr <Plug>(coc-rename)
nmap <silent> gf :call CocAction('format')<cr>
nmap <silent> ga  <Plug>(coc-codeaction)
nmap <silent> g<enter>  <Plug>(coc-fix-current)
nmap <silent> gh :call CocAction('doHover')<cr>
nmap <silent> go :call CocAction('runCommand', 'editor.action.organizeImport')<cr>
"### LEADER ############################
nnoremap <silent><nowait> <leader>id :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <leader>ie :<C-u>CocList extensions<cr>
nnoremap <silent><nowait> <leader>ic :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <leader>io :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <leader>is :<C-u>CocList -I symbols<cr>
"### YANK ##############################
nnoremap <silent> <space>y :<C-u>CocList -A --normal yank<cr>

"### HIGHTLIGHT CURRENT ################
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

"### COMMAND SELECTOR ##################
map <C-P> :CocCommand<cr>

"#######################################
"### SNIPPETS                        ###
"#######################################

" Plugin: coc-snippets [coc.vim]
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)
" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)
" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'
" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'
" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)


"#######################################
"### COMPATABILITY                   ###
"#######################################

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

"#######################################
"### HELPER FUNCTIONS                ###
"#######################################

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
