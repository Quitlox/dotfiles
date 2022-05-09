if !has('nvim') | finish | endif

lua << EOF
require('nvim-web-devicons').setup {
  default = true
}
EOF
