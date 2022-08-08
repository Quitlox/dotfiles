
if !empty(glob("~/.config/vim/settings/colorscheme.vim"))
  source ~/.config/vim/settings/colorscheme.vim
else
  colorscheme codedark
  let g:airline_theme='codedark'

  set fillchars=eob:\ ,

  hi Normal ctermfg=None ctermbg=None
  hi EndOfBuffer ctermfg=None ctermbg=None
  hi LineNr ctermfg=None ctermbg=None
  hi SignColumn ctermfg=None ctermbg=None
  hi Directory ctermfg=None ctermbg=None
  hi WhichKeyFloat ctermfg=None ctermbg=None
endif
