if !has('nvim')
    let g:Illuminate_useDeprecated = 1
    let g:Illuminate_delay = 1000
    let g:Illuminate_ftblacklist = ['fugitive', 'NvimTree', 'nerdtree']
    let g:Illuminate_highlightUnderCursor = 0
else
lua << EOF
require('illuminate').configure({
    delay = 1000,
    filetypes_denylist = {
        'dirvish',
        'fugitive',
        'nerdtree',
        'NvimTree',
    },
    under_cursor = true,
    large_file_cutoff = 10000,
})
EOF
endif
