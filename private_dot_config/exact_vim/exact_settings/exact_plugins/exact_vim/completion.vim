if !(dein#is_available(['coc.nvim'])) | finish | endif

"#######################################
"### SETTINGS                        ###
"#######################################

" Encoding
set encoding=utf-8
" Performance
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

set pyxversion=3

let g:coc_config_home = '~/.config/vim'
let g:coc_global_extensions = [
            \ 'coc-bootstrap-classname',
            \ 'coc-css', 'coc-eslint', 'coc-git',
            \ 'coc-html',
            \ 'coc-htmldjango', 'coc-html-css-support',
            \ 'coc-json',
            \ 'coc-marketplace', 'coc-prettier',
            \ 'coc-pyright',
            \ 'coc-rls', 'coc-rust-analyzer', 'coc-sh',
            \ 'coc-snippets',
            \ 'coc-tailwindcss', 'coc-tsserver',
            \ 'coc-toml', 'coc-vimlsp', 'coc-vimtex',
            \ 'coc-yaml',
            \ 'coc-yank', 'coc-xml'
            \]

let g:coc_default_semantic_highlight_groups = 1

"### HIGHTLIGHT CURRENT ################
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

"#######################################
"### COMPLETION TRIGGER              ###
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
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

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

nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)
nmap <silent> [e <Plug>(coc-diagnostic-prev-error)
nmap <silent> ]e <Plug>(coc-diagnostic-next-error)
nmap <F2> <Plug>(coc-rename)

""" LEADER MAPPINGS """"""""""""""""""""
let g:which_key_map.i = { 'name': 'IDE' }
let g:which_key_map.i.d = 'IDE Diagnostics'
let g:which_key_map.i.e = 'IDE Extensions'
let g:which_key_map.i.o = 'IDE Outline'
let g:which_key_map.i.s = 'IDE Symbols'
let g:which_key_map.i.l = 'IDE List'
let g:which_key_map.i.m = 'IDE Marketplace'
let g:which_key_map.i.c = 'IDE Commands'

nnoremap <silent><nowait> <leader>id :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <leader>ie :<C-u>CocList extensions<cr>
nnoremap <silent><nowait> <leader>io :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <leader>is :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <leader>il :<C-u>CocList<cr>
nnoremap <silent><nowait> <leader>im :<C-u>CocList marketplace<cr>
nnoremap <silent><nowait> <leader>ic :<C-u>CocList commands<cr>

""" LEADER MAPPINGS """"""""""""""""""""
let g:which_key_map.o = {'name':'Open'}
let g:which_key_map.o.s = 'Open Symbols'
nnoremap <silent><nowait> <leader>is :<C-u>CocList -I symbols<cr>

""" YANK """""""""""""""""""""""""""""""
let g:which_key_map.y = 'CoC Yanklist'
nnoremap <silent> <space>y :<C-u>CocList -A --normal yank<cr>

""" GO """""""""""""""""""""""""""""""""
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gf :call CocAction('format')<cr>
nmap <silent> ga  <Plug>(coc-codeaction)
xmap <silent> ga  <Plug>(coc-codeaction)
nmap <silent> g<enter>  <Plug>(coc-fix-current)
nmap <silent> gh :call CocAction('doHover')<cr>
nmap <silent> go :call CocAction('runCommand', 'editor.action.organizeImport')<cr>
let g:which_key_go_map.d = 'definition'
let g:which_key_go_map.y = 'type definition'
let g:which_key_go_map.i = 'implementation'
let g:which_key_go_map.r = 'references'
let g:which_key_go_map.f = 'format'
let g:which_key_go_map.a = 'code-action'
let g:which_key_go_map["<CR>"] = 'fix-current'
let g:which_key_go_map.h = 'hover'
let g:which_key_go_map.o = 'organise imports'

""" SNIPPETS """""""""""""""""""""""""""
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
  " Scroll using <C-u> <C-d>
  nnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

  " Scroll using <C-j> <C-k>
  nnoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1, 1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0, 1) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1, 1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0, 1)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1, 1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0, 1) : "\<C-b>"

  nnoremap <silent><nowait><expr> <esc> coc#float#has_scroll() ? coc#float#close_all() : "\<esc>"
  vnoremap <silent><nowait><expr> <esc> coc#float#has_scroll() ? coc#float#close_all() : "\<esc>"
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
