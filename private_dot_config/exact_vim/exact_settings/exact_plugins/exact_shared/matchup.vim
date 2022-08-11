"#######################################
"### Matchup                         ###
"#######################################

if has('nvim')
lua <<EOF
    require'nvim-treesitter.configs'.setup {
      matchup = {
        enable = true,
      },
    }
EOF
end
