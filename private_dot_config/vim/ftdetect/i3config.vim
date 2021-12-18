" The plugin for i3 syntax highlighting does not detect
" the file ~/.config/i3/config
"
" https://github.com/mboughaba/i3config.vim
aug i3config_ft_detection
  au!
  au BufNewFile,BufRead ~/.config/i3/config set filetype=i3config
aug end
