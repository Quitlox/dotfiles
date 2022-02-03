" Polybar does not need dedicated syntax highlighting
" The config file is of type dosini
aug polybar_ft_detection
  au!
  au BufNewFile,BufRead ~/.config/polybar/config set filetype=dosini
aug end
