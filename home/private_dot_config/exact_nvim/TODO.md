- Changes
    - [ ] Update gp.nvim configuration
    - [ ] Prettify Tab-bar
    - [ ] Streamline overseer.nvim integration with snacks.terminal (requires testing, heracles would be a good example)
    - [ ] Wwitch from possesion to resession
        - [ ] make neotest behave after switching session
        - [ ] wrong tab being opened on restore (due to notify, neo-tree?)
            reproduce: knowledge-base, tab 1 (neo-tree, md), tab 2 (python, chatgpt)
        - [ ] Do not ask to save changes to "Neotest Output Panel" and "[dap-repl]"
        - [ ] Restore terminal with sessions
        - [ ] if no restore, then source venv if active
    - [ ] Overseer:
        - [ ] "OverseerQuickAction duplicate" would be convenient
        - [ ] OverseerSaveBundle opens input in seemingly random location
    - [ ] Replace targets.nvim and treesitter-textobjects with mini.ai and <swap plugin>
- Bugs:
    - [ ] kitty settings are reverted when another neovim instance is opened

- [ ] To Investigate
    - [ ] dap-ui: "DAP Watches" shows up as listed buffer in bufferline if edited
    - [ ] snacks.profile: investigate sluggishness when switching windows from
      terminal into LSP enabled window (python)
    - [ ] hang while exiting neovim
- Requires Contribution:
    - [ ] overseer: map <esc> in help_win (not configurable currently)
    - [ ] treewalker.nvim: allow skipping certain nodes
    - [ ] treewalker.nvim: automatically disable in buffers without parsers/lang

Desktop:
- [ ] Eww: Bar should use fill icons on select
- [ ] Hypr: Configure coding workspace with auto-centered neovide?


### Memorandum
- Help File Navigation: Hit `gO` to open an outline in the help file.
- In insert mode, use `<C-o>` to execute a normal mode command.

