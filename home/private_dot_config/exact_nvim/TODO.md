
- [ ] Plugins:
    - [ ] switch from possesion to resession
        - [ ] make neotest behave after switching session
        - [ ] wrong tab being opened on restore (due to notify, neo-tree?)
            reproduce: knowledge-base, tab 1 (neo-tree, md), tab 2 (python, chatgpt)
        - [ ] Do not ask to save changes to "Neotest Output Panel" and "[dap-repl]"
        - [ ] Restore terminal with sessions
    - [x] Replace cmp with blink.cmp
    - [x] Add treewalker.nvim
    - [ ] Update gp.nvim configuration
- [ ] Features:
    - [x] bufferline.nvim: disable
        - [ ] prettify tabbar
    - [ ] Overseer:
        - [ ] "OverseerQuickAction duplicate" would be convenient
        - [ ] OverseerSaveBundle opens input in seemingly random location
    - [ ] Terminal:
        - [x] Build custom behaviour to have tab-local tabs
        - [x] basic integration overseer with snacks.terminal
            - [ ] improve integration
        - [x] In terminal insert mode, the cursor should be a line 
            Fix merged five days ago into neovim!
    - Editing
        - [x] setup navigation for subwords using <C-B> and <C-E>
        - [ ] Replace targets.nvim and treesitter-textobjects with mini.ai and
          <swap plugin>
- [ ] Bugs:
    - [x] autopairs: lua functions not being auto-closed
    - [ ] terminal: does not show venv if already activated on startup
- [ ] Miscellenous:
    - [ ] only render window seperators for editor windows
    - [ ] neo-tree: figure out how to keep filter
    - [ ] zsh: <esc>c opens fzf which is frustrating
    - [ ] venv-selector:
        - [ ] cannot find venv when not in python file
    - [ ] python:
        - [ ] skip decorators while navigating functions

- [ ] To Investigate
    - [ ] dap-ui: "DAP Watches" shows up as listed buffer in bufferline if edited
    - [ ] snacks.profile: investigate sluggishness when switching windows from
      terminal into LSP enabled window (python)
    - [ ] hang while exiting neovim
- Requires Contribution:
    - [ ] overseer: map <esc> in help_win (not configurable currently)
    - [ ] treewalker.nvim: allow skipping certain nodes
    - [ ] treewalker.nvim: automatically disable in buffers without parsers/lang

- search for symbol: use fzy?

Desktop:
- [ ] Eww: Bar should use fill icons on select
- [ ] Hypr: Configure coding workspace with auto-centered neovide?


### Memorandum
- Help File Navigation: Hit `gO` to open an outline in the help file.
- In insert mode, use `<C-o>` to execute a normal mode command.

