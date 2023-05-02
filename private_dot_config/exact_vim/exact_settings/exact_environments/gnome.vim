if &term != 'gnome' | finish | endif
echo "Loaded gnome configuration"

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

