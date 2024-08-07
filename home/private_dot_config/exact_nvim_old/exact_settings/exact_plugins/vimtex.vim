
"#######################################
"### Vimtex Plugin                   ###
"#######################################

""""""""""""""""""""""""""""""""""""""""
" => Settings
""""""""""""""""""""""""""""""""""""""""

" In Neovim, we use the lsp
if has('nvim')
    let g:vimtex_syntax_enabled=0
    let g:vimtex_complete_enabled=0
    let g:vimtex_format_enabled=0
    let g:vimtex_indent_enabled=0 " Should be arranged by treesitter?
    let g:vimtex_indent_bib_enabled=0
    let g:vimtex_matchparen_enabled=0
    let g:vimtex_quickfix_enabled=1
    let g:vimtex_syntax_enabled=1
endif

" Windows
if has('win32') || has('win64')
  let g:vimtex_view_method = 'sioyek'
  " Be sure to add sioyek to PATH. The method below doesn't work for some reason
  " let g:vimtex_view_sioyek_exe = "C:\Users\witloxkhd\Applications\sioyek\sioyek.exe"
endif

" Linux or Windows WSL
if has('unix')
  if executable('sioyek.exe')
    " Only available in Windows WSL
    let g:vimtex_view_method = 'sioyek'
    let g:vimtex_view_sioyek_exe = 'sioyek.exe'
    let g:vimtex_callback_progpath = 'wsl nvim'

    " On event VimtexEventCompileSuccess, execute "sioyek.exe --execute-command reload""
    " For some reason, sioyek doesn't pick up file changes when using wsl nvim
    function! s:sioyek_reload() abort
        let l:cmd = ['sioyek.exe', '--execute-command', 'reload']
        let job_id = jobstart(l:cmd, {
                    \ 'on_exit': function('s:on_sioyek_exit'),
                    \ })

        if job_id = 0
            call luaeval('vim.notify("Failed to reload sioyek", "error")')
        endif
    endfunction

    function! s:on_sioyek_exit(job_id, exit_status, event) abort
        echom 'Sioyek exited with code: ' . a:exit_status
    endfunction

    autocmd User VimtexEventCompileSuccess call s:sioyek_reload()

  else
    let g:vimtex_quickfix_method = 'pplatex'
    let g:vimtex_view_method = 'zathura'
  endif
endif

" Quickfix
"let g:vimtex_quickfix_autojump = 1
let g:vimtex_quickfix_mode = 0
" ToC
let g:vimtex_toc_config = {
            \ 'split_pos': 'vert rightbelow',
            \}


" Editor
let g:matchup_override_vimtex = 1
" Documentation
let g:vimtex_doc_handlers = ['vimtex#doc#handlers#texdoc']
" Indent
let g:vimtex_indent_conditionals = {
      \ 'open': '\v%(%(\\newif)@<!\\if%(f>|field|name|numequal|thenelse)@!)|%(\\pcfor>)',
      \ 'else': '\\else\>',
      \ 'close': '%(\\fi\>)|%(\\pcendfor\>)',
      \}

" Conceal
let g:vimtex_syntax_conceal = {
            \ 'accents': 1,
            \ 'cites': 1,
            \ 'fancy': 1,
            \ 'greek': 1,
            \ 'math_bounds': 1,
            \ 'math_delimiters': 1,
            \ 'math_fracs': 1,
            \ 'math_super_sub': 1,
            \ 'math_symbols': 1,
            \ 'sections': 1,
            \ 'styles': 1,
            \}

" Ignore useless quickfix
let g:vimtex_quickfix_ignore_filters = [
      \ 'Underfull \\hbox',
      \ 'Overfull \\hbox',
      \ 'LaTeX Warning: .\+ float specifier changed to',
      \ 'LaTeX hooks Warning',
      \ 'Package siunitx Warning: Detected the "physics" package:',
      \ 'Package hyperref Warning: Token not allowed in a PDF string',
      \]
