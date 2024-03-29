
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Manager: dein.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""  dein.vim  """""""""""""""""""""""""

if &compatible
  set nocompatible " Be iMproved
endif

" Required:
if has('nvim')
  let deinbasepath=$HOME . '/.local/share/nvim/bundle'
else
  let deinbasepath=$HOME . '/.local/share/vim/bundle'
endif

let deininstallpath=deinbasepath . '/repos/github.com/Shougo/dein.vim'
exe 'set rtp+=' . deininstallpath
let &rtp=$HOME . '/.config/vim' . ',' . &rtp

" Required:
call dein#begin(deinbasepath)


call dein#add(deininstallpath)


"""""""""""""""  dein.vim """"""""""""""""""""""""""""""""""

" Plugin: Dein UI
" Link: https://github.com/wsdjeg/dein-ui.vim
" Official Description: UI for Shougo's dein.vim.
"
" This adds a simple popup-as-needed UI element that
" displays the status of dein.vim while installing plugins.
" Call with ':DeinUpdate'
call dein#add('wsdjeg/dein-ui.vim')

" Plugin: Dein Command
" Link: https://github.com/haya14busa/dein-command.vim
" Official Description: Utility commands of dein.vim with
" rich completion
call dein#add('haya14busa/dein-command.vim')


" TODO:
"   - codi !
"   - characterize
"   - vim space controller
"   - argwrap
"   - vimoutliner
"   - vim diminactive
"   - vim sandwich

" Plugins discarded that might be worth looking into again:
"   - delimitmate: auto close tags
"   - pencil: writing mode
"   - vim-repl, iron: REPL
"   - tagbar: tag support
"   - asynctasks
"   - vim-ulttest: unit testing

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => User Interface
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugin: vim-maximizer
" Link: https://github.com/szw/vim-maximizer
" Official Description: Maximizes and restores the current window in Vim.
call dein#add('szw/vim-maximizer')

"""""""""""""""""""""""""""""
" => User Interface: WhichKey
"""""""""""""""""""""""""""""

" Plugin: Vim-which-key
" Link: https://vimawesome.com/plugin/vim-which-key#introduction
"
" This utility displays available keybindings in a popup.
" Activate by pressing the leader key.
call dein#add('liuchengxu/vim-which-key')

"""""""""""""""""""""""""""""
" => User Interface: File Explorer
"""""""""""""""""""""""""""""

" Plugin: NERDTree
" Link: https://github.com/preservim/nerdtree
" Official Description: The NERDTree is a file system
" explorer for the Vim editor. Using this plugin, users can
" visually browse complex directory hierarchies, quickly
" open files for reading or editing, and perform basic file
" system operations.
call dein#add('preservim/nerdtree')


" Plugin: nerdtree-git-plugin
" Link: https://github.com/Xuyuanp/nerdtree-git-plugin
" Official Description: A plugin of NERDTree showing git
" status flags.
call dein#add('Xuyuanp/nerdtree-git-plugin')

" Plugin: vim-nerdtree-syntax-highlight
" Link: https://github.com/tiagofumo/vim-nerdtree-syntax-highlight
" Official Description: This adds syntax for nerdtree on
" most common file extensions. [..] This is intended to be
" used with vim-devicons to add color to icons ore entire
" labels, but will work without it.
call dein#add('tiagofumo/vim-nerdtree-syntax-highlight')

"""""""""""""""""""""""""""""
" => User Interface: Statusline
"""""""""""""""""""""""""""""

" Plugin: Vim-Airline
" Link: https://vimawesome.com/plugin/vim-airline-superman
" Official Description: Lean & mean status/tabline for vim
" that's light as air.
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')

"""""""""""""""""""""""""""""
" => User Interface: Miscelaneous
"""""""""""""""""""""""""""""

" Plugin: VimDevIcons
" Link: https://github.com/ryanoasis/vim-devicons
" Official Description: Adds Icons to Your Plugins
call dein#add('ryanoasis/vim-devicons')

" Plugin: goyo.vim
" Link: https://vimawesome.com/plugin/goyo-vim
" Official Description: Distraction-free writing in Vim.
call dein#add('junegunn/goyo.vim')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => IDE - Integrated Development Environment
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""
" => IDE: Git (Fugitive)
"""""""""""""""""""""""""""""

" Plugin: Fugitive
" Link: https://github.com/tpope/vim-fugitive
" Official Description: A Git wrapper so awesome, it should
" be illegal.
call dein#add('tpope/vim-fugitive')

"""""""""""""""""""""""""""""
" => IDE: Search
"""""""""""""""""""""""""""""

" Plugin: ctrlp.vim
" Link: https://github.com/ctrlpvim/ctrlp.vim
" Official Description: Full path fuzzy file, buffer, mru,
" tag, ... finder for Vim.
"
" Simple UI element that popups under your statusline that
" allows you to fuzzy-search your files and buffers.
" Default mapping on ctrl+p, who would've thought.
call dein#add('ctrlpvim/ctrlp.vim')


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""
" => Vim: Commands
"""""""""""""""""""""""""""""

" Plugin: Bbye (Buffer Bye) for Vim
" Link: https://github.com/moll/vim-bbye
" Official Description: Dlete buffers and close files in Vim
" without closing your windows or messing up your layout.
call dein#add('moll/vim-bbye')

"""""""""""""""""""""""""""""
" => Vim: Motions, Verbs
"""""""""""""""""""""""""""""

" Plugin: EasyMotion
" Link: https://vimawesome.com/plugin/easymotion
" Official Description: EasyMotion provides a much simpler
"
" way to use some motions in vim. It takes the <number> out
" of <number>w or <number>f{char} by highlighting all
" possible choices and allowing you to press one key to jump
" directly to the target.
call dein#add('easymotion/vim-easymotion')

" Plugin: surround.vim
" Link: https://vimawesome.com/plugin/surround-vim
" Official Description: Surround.vim is all about
" "surroundings": parentheses, brackets, quotes, XML tags,
" and more. The plugin provides mapping to easily delete,
" change and add such surroundings in pairs.
"
" Introduces a new verb, namely 'surround', bound to the 's'
" key. This verb allows you to easily add and manipulate
" quotes, paranthesis and HTML tags around words and lines.
call dein#add('tpope/vim-surround')

" Plugin: repeat.vim
" Link: https://github.com/tpope/vim-repeat
"
" Small helper plugin that remaps '.' to work with plugin
" mappings.
call dein#add('tpope/vim-repeat')

" Plugin: vim-indent-object
" Link: https://github.com/michaeljsmith/vim-indent-object
" Official Description: Vim plugin that defines a new text object representing
" lines of code at the same indent leven. Useful for python/vim scripts, etc.
call dein#add('michaeljsmith/vim-indent-object')

" Plugin: Clever F
" Link: https://github.com/rhysd/clever-f.vim
" Official Description: Extended f, F, t, and T key mappings for Vim.
call dein#add('rhysd/clever-f.vim')

" Plugin: vim match-up
" Link: https://github.com/andymass/vim-matchup
" Official Description: Even better % Navigate and highlight matching words
" Modern matchit and matchparen
call dein#add('andymass/vim-matchup')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editor
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugin: Zotcite
" Link: https://github.com/jalvesaq/zotcite
" Official Description: Vim plugin for integration with Zotero
call dein#add('jalvesaq/zotcite')

"""""""""""""""""""""""""""""
" => Editor: Hints
"""""""""""""""""""""""""""""

" Plugin: CSS color
" Link: https://vimawesome.com/plugin/vim-css-color-the-story-of-us
" Official Description: A very fast, multi-syntax
" context-sensitive color name highlighter.
call dein#add('ap/vim-css-color')


" Plugin: Rainbow Parentheses Improved
" Link: https://github.com/luochen1990/rainbow
"
" Colors Parentheses and brackets to make the different
" pairs more easily distinguishable.
call dein#add('luochen1990/rainbow', {'merged': 0})


" Plugin: Indentline
" Link: https://vimawesome.com/plugin/indentline
" Official Description: This plugin is used for displaying
" thin vertical lines at each indentation level for code
" indented with spaces.
call dein#add('yggdroot/indentline')

" Plugin: Illuminate
" Link: https://github.com/RRethy/vim-illuminate
" Official Description: Vim plugin for automatically highlighting other uses
" of the word under the cursor.
call dein#add('RRethy/vim-illuminate')

"""""""""""""""""""""""""""""
" => Editor: Actions
"""""""""""""""""""""""""""""

" Plugin: Vim Better Whitespace Plugin
" Link: https://vimawesome.com/plugin/better-whitespace
" Official Description: This plugin causes all trailing
" whitespace characters to be highlighted. Whtiespace for
" the current line will note be highlighted while in insert
" mode. It is possible to disable current line highlighting
" while in other modes as well. A helper function
" ':StripWhitespace' is also provided to make whitespace
" cleaning painless.
call dein#add('ntpeters/vim-better-whitespace')


" Plugin: TComment
" Link: https://github.com/tomtom/tcomment_vim
" Official Description: An extensible & universal comment vim-plugin that also
" handles embedded filetypes
call dein#add('tomtom/tcomment_vim')

" Plugin: Documentation Generator
call dein#add('kkoomen/vim-doge')

"""""""""""""""""""""""""""""
" => Editor: Auto-configuration
"""""""""""""""""""""""""""""

" Plugin: Sleuth.vim
" Link: https://vimawesome.com/plugin/sleuth-vim
" Official Description: This plugin automatically adjusts
" 'shiftwidth' and 'expandtab' heuristically based on the
" current file, or, in the case the current file is new,
" blank, or otherwise insufficient, by looking at other
" files of the same type in the current and parent
" directories. In lieu of adjusting 'softtabstop',
" 'smarttab' is enabled.
call dein#add('tpope/vim-sleuth')


" Plugin: vim-lastplace
" Link: https://vimawesome.com/plugin/vim-lastplace
" Official Description: Intelligently reopen files at your
" last edit position.
call dein#add('farmergreg/vim-lastplace')

" Plugin: vim-context-commentstring
" Link: https://github.com/suy/vim-context-commentstring/
" Official Description: Vim plugin that sets the value of 'commentstring' to
" a different value depending on the region of the file you are in.
call dein#add('suy/vim-context-commentstring/')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Language Support
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugin: coc.vim
" Link: https://github.com/neoclide/coc.nvim
" Official Description: Make your Vim/Neovim as smart as
" VSCode.
call dein#add('neoclide/coc.nvim', {'merged': 0, 'rev': 'release'})

"""""""""""""""""""""""""""""
" => Languages
"""""""""""""""""""""""""""""

" Plugin: vimtex
" Link: https://github.com/lervag/vimtex
" Official Description: VimTeX is a modern Vim and Neovim
" filetype and syntax plugin for LaTeX files.
call dein#add('lervag/vimtex')


" Plugin: Vim Markdown
" Link: https://github.com/plasticboy/vim-markdown
" Official Description: Syntax highlighting, matching rules
" and mappings for the original Markdown and extensions.
call dein#add('plasticboy/vim-markdown')

" Plugin: vim-graphql
" Link: https://github.com/jparise/vim-graphql
" Official Description: A Vim plugin that provides GraphQL
" file detect, syntax highlighting and indentation.
call dein#add('jparise/vim-graphql')

"""""""""""""""""""""""""""""
" => Syntax Highlighting
"""""""""""""""""""""""""""""

" Plugin: i3config.vim
" Link: https://github.com/mboughaba/i3config.vim
"
" Syntax Highlighting for the i3 config file
call dein#add('mboughaba/i3config.vim')

" Plugin: vim-kitty
" Link: https://github.com/fladson/vim-kitty
" Official Description: Syntax highlighting for Kitty
" terminal config files.
call dein#add('fladson/vim-kitty')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Compatability & Sanity
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugin: Terminus
" Link: https://github.com/wincent/terminus
" Official Description: Terminus enhances Vim's and Neovim's
" integration with the terminal in four ways, particularly
" when using tmux and iTerm or KDE Konsole, closing the gap
" between terminal and GUI Vim.
"
" Stuff it does:
" - Cursor Shape
" - Improved Mouse Suppor
" - Focus Reporting
" - Bracketed Paste mode
call dein#add('wincent/terminus')

if !has('nvim')
" Plugin: vim-paste-easy
" Link: https://github.com/roxma/vim-paste-easy
" Official Description: Automatically set paste for you
call dein#add('roxma/vim-paste-easy')
endif

" Plugin: Obsession
" Link: https://github.com/tpope/vim-obsession
" Official Description: Continuously updated session files
call dein#add('tpope/vim-obsession')

"""""""""""""""""""""""""""""
" => Chezmoi
"""""""""""""""""""""""""""""

" Plugin: chezmoi.vim
" Link: https://github.com/alker0/chezmoi.vim
" Official Description: Highlight dotfiles you manage with
" chezmoi.
"
" This plugin fixes syntax highlighting by resolving the
" chezmoi modifiers (.tmp, dot_) in the chezmoi directory.
call dein#add('alker0/chezmoi.vim')

" Plugin: vim-chezmoi
" Link: https://github.com/Lilja/vim-chezmoi
" Official Description: Let's you apply files on write
" to chezmoi.
"
" This plugin automatically applies changes to dotfiles
call dein#add('Lilja/vim-chezmoi')
let g:chezmoi = "enabled"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Miscellaneous
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugin: sudo.vim
" Link: https://vimawesome.com/plugin/sudo-vim
" Official Description: This script eases use of vim with
" sudo by adding the ability to edit one file with root
" privileges without running the whole session that way.
call dein#add('vim-scripts/sudo.vim')

" Plugin: localvimrc
" Link: https://github.com/embear/vim-localvimrc
" Official Description: Search local vimrc (".vimrc") in
" the tree (root dir up to current dir) and load them.
call dein#add('embear/vim-localvimrc')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colorschemes
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugin: AfterColors.vim
" Link: https://github.com/vim-scripts/AfterColors.vim
" Official Description: Provides support for after/colors/
" scripts.
call dein#add('vim-scripts/AfterColors.vim')

call dein#add('tomasiser/vim-code-dark')
call dein#add('altercation/vim-colors-solarized')

"""""""""""""""""""""""  dein.vim  """""""""""""""""""""""""

" Required:
call dein#end()

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif


