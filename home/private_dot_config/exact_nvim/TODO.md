
- [ ] Plugins:
    - [ ] Replace telescope with fzf/fzy?
    - [ ] Replace cmp with blink.cmp
    - [ ] Add treewalker.nvim
- [ ] Features:
    - [ ] bufferline.nvim: disable
    - [ ] Overseer:
        - [ ] "OverseerQuickAction duplicate" would be convenient
        - [x] Keybinding X to stop all
        - [ ] OverseerSaveBundle opens input in seemingly random location
    - [ ] Terminal:
        - [x] Replace toggleterm with lighter snacks.terminal
        - [x] Build custom behaviour to have tab-local tabs
        - [ ] Restore terminal with sessions
        - [x] basic integration overseer with snacks.terminal
            - [ ] improve integration
        - [x] In terminal insert mode, the cursor should be a line 
            Fix merged five days ago into neovim!
        - [x] Change terminal lualine color to differentiate mode
        - [x] add lazygit terminal with snacks.terminal
        - [x] Change background color depending on mode
    - Editing
        - [x] tabs: setup navigation with ]<tab> and [<tab>
        - [x] setup navigation for subwords using <C-B> and <C-E>
        - [ ] Replace targets.nvim and treesitter-textobjects with mini.ai and
          <swap plugin>
- [ ] Bugs:
    - [ ] dap: Debugging leaves typehints once dapui is closed (specifically osv)
    - [x] autopairs: lua functions not being auto-closed
    - [ ] terminal: does not show venv if already activated on startup
    - [x] restore bufdelete (behaviour of snacks is not desired)
    - [ ] cursor should not focus notification on restore
    - Possession:
        - [ ] do not show error when no session is found
        - [ ] do not focus notification on restore
        - [x] autosave not working
        - [ ] Do not ask to save changes to "Neotest Output Panel" and "[dap-repl]"
        - [ ] make neotest behave after switching session
        - [ ] state is not consistent. order changes, sometimes buffers get dropped
            - Keeps opening COMMIT_MSG (or other random files) for some reason
- [ ] Miscellenous:
    - [ ] Only render window seperators for editor windows


- [ ] To Investigate
    - [ ] osv: error is thrown while debugging neovim through osv
    - [ ] dap-ui: "DAP Watches" shows up as listed buffer in bufferline if edited
    - [ ] snacks.profile: investigate sluggishness when switching windows from
      terminal into LSP enabled window (python)
    - [ ] snacks.profile: throws error when profiling
    - [ ] hlslens: generally buggy when opening floats (e.g. glance)
- Requires Contribution:
    - [ ] overseer: map <esc> in help_win (not configurable currently)

Desktop:
- [ ] Eww: Bar should use fill icons on select
- [ ] Hypr: Configure coding worksapce with auto-centered neovide?


### Memorandum
- Help File Navigation: Hit `gO` to open an outline in the help file.
- In insert mode, use `<C-o>` to execute a normal mode command.

