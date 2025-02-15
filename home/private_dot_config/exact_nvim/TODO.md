- Changes
    - [ ] when going to a definition outside of the cwd, open a new tab and set the tcd
    - [ ] Go over all commands, check if enough are present
    - [ ] Go over all plugins and contribute sane defaults
    - [ ] Go over all plugins and use Snacks.on_module for integrations to prevent errors if module uninstalled
        - I need a shorthand for throwing an error if a module is not present,
          optionally with a message

    - [ ] Adopt remote-nvim.nvim
    - [ ] Adopt Obsidian.nvim
    - [ ] Switch from possesion to resession
    - [ ] Overseer:
        - [ ] "OverseerQuickAction duplicate" would be convenient

    - Projects per Tab:
        - [ ] sessions: main problem is the integration with a session manager
            the session manager must handle tcd and only set the window layout of the current tab
            maybe I should instead move away from autoloading sessions
            I also have to stop depending on bufferline, as this interferes with
            the idea of using the tabline to switch between projects
        - [ ] neotest: detach when switching projects / sessions
                neotest has no built-in method for doing this

    - [ ] Switch to SemVer for Gitsigns (v1.0.0) is out.   
- Bugs:
    - [ ] possession: wrong tab being opened on restore (due to notify, neo-tree?)
            reproduce: knowledge-base, tab 1 (neo-tree, md), tab 2 (python, chatgpt)
    - [ ] jsonls not starting?
    - [ ] markdown documents seem to have incorrect whitespace chars (example, '~/.config/nvim/rocks.toml').
        related seems that backspace on first column of line in these files doesn't work
    - <esc> in lazygit doesn't work

- stacktrace on startup, sometimes:
```log
Error executing vim.schedule lua callback: ...uitlox/.local/share/nvim/rocks/rocks_rtp/lua/lualine.lua:407: Error executing lua: ...e-pretty-path/lua/lualine-pr
etty-path/providers/base.lua:87: attempt to index field 'path' (a nil value)                                                                                    
stack traceback:                                                                                                                                                
        ...e-pretty-path/lua/lualine-pretty-path/providers/base.lua:87: in function 'extract_scheme'                                                            
        ...e-pretty-path/lua/lualine-pretty-path/providers/base.lua:74: in function 'parse'                                                                     
        ...e-pretty-path/lua/lualine-pretty-path/providers/base.lua:44: in function 'init'                                                                      
        ...l/share/nvim/rocks/rocks_rtp/lua/lualine/utils/class.lua:34: in function 'new'                                                                       
        ...aline-pretty-path/lua/lualine/components/pretty_path.lua:155: in function 'update_status'                                                            
        ...cal/share/nvim/rocks/rocks_rtp/lua/lualine/component.lua:273: in function 'draw'                                                                     
        ...share/nvim/rocks/rocks_rtp/lua/lualine/utils/section.lua:26: in function 'draw_section'                                                              
        ...uitlox/.local/share/nvim/rocks/rocks_rtp/lua/lualine.lua:167: in function 'statusline'                                                               
        ...uitlox/.local/share/nvim/rocks/rocks_rtp/lua/lualine.lua:295: in function <...uitlox/.local/share/nvim/rocks/rocks_rtp/lua/lualine.lua:276>          
        [C]: in function 'nvim_win_call'                                                                                                                        
        ...uitlox/.local/share/nvim/rocks/rocks_rtp/lua/lualine.lua:407: in function 'refresh'                                                                  
        ...uitlox/.local/share/nvim/rocks/rocks_rtp/lua/lualine.lua:523: in function <...uitlox/.local/share/nvim/rocks/rocks_rtp/lua/lualine.lua:520>          
stack traceback:                                                                                                                                                
        [C]: in function 'nvim_win_call'                                                                                                                        
        ...uitlox/.local/share/nvim/rocks/rocks_rtp/lua/lualine.lua:407: in function 'refresh'                                                                  
        ...uitlox/.local/share/nvim/rocks/rocks_rtp/lua/lualine.lua:523: in function <...uitlox/.local/share/nvim/rocks/rocks_rtp/lua/lualine.lua:520>
```

- [ ] To Investigate
    - [ ] snacks.profile: investigate sluggishness when switching windows from
      terminal into LSP enabled window (python) -> its linting, but why
    - [x] which-key: add description to mini.ai
    - [ ] edgy: on open explorer, windows should be resized
    - [x] mini.ai: in python ci" should also capture f-strings
    - [ ] pymple: not working, probably due to virtual environment

- Requires Contribution:
    - [ ] treewalker.nvim: allow skipping certain nodes
    - [ ] treewalker.nvim: automatically disable in buffers without parsers/lang
    - [ ] rocks.nvim: provide warning for outdated plugins (both scm vs git and pin vs scm)
    - [ ] navic: should provide symbol filter, but maintainer is inactive
    - [ ] overseer: map <esc> in help_win (not configurable currently)
    - [ ] overseer: jk should move to job in OverseerTaskList, not step around
    - [ ] overseer: term should scroll to bottom automatically
    - [ ] overseer: background tasks should not be awaited for completion
    - [ ] overseer: add option to not autorestart isBackground tasks 
    - [x] blink.cmp: the char / should be a trigger for the path source
    - [ ] navic: doesn't work with arrow, same context in all windows
    - [ ] rocks:
        - [ ] should not update git to older version tag if ver is specified to be a newer commit
        - [ ] toml-edit should keep inline items as inline
        - [ ] toml edit should not move the comments  
    - [ ] nvim-dap-ui: closing dap with editor splits sets winfixwidth, causing
      the windows not to resize properly
        - https://github.com/rcarriga/nvim-dap-ui/issues/175
        - https://github.com/rcarriga/nvim-dap-ui/issues/260
    - [ ] hover.nvim: allow changing priority of providers
        I want LSP to be higher than Diagnostic, as I can already directly open
        the diagnostic using ]d and [d
    - [ ] nvim-dap-ui / overseer: after using debugging, the mappings over the
        overseer window are no longer available (or its because cannot make changes,
        'modifiable' is off)
    - [ ] nvim-dap-ui: on second debug session, repl is not available
        there is a repl window, but it has the generic name "dap-repl-198" and
        doesn't show anything.
    - [ ] dap-ui: watches window should allow delete on partial line (with ">")

- Requires Contribution (hard-to-fix):
    - [ ] nvim: <BS> and <C-BS> have odd behaviour in DAP REPL and DAP Watches
        - https://github.com/rcarriga/nvim-dap-ui/issues/31
        - https://github.com/neovim/neovim/issues/14116
    - [ ] neovide: misalignment character rendered in lualine (powershell symbol)
        - https://github.com/neovide/neovide/issues/2491
    - [ ] resession: plugin for restoring shell contents
        should be doable?
    - [ ] blink.cmp: rewrite cmp-dap for blink.cmp. (it's quite a small plugin) 

- Contribute back, sane defaults, low priority:
    - [ ] overseer.nvim: task view has not filetype
    - [ ] overseer.nvim: my custom dispose_all, restart_all commands
    - [ ] nvim-treesitter-textobjects / mini.ai: python @string.inner / @string.outer

Desktop:
- [ ] Eww: Bar should use fill icons on select
- [ ] Hypr: Configure coding workspace with auto-centered neovide?


### Memorandum
- Help File Navigation: Hit `gO` to open an outline in the help file.
- In insert mode, use `<C-o>` to execute a normal mode command.

