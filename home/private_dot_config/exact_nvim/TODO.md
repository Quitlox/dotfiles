- Changes
    - [ ] Adopt remote-nvim.nvim
    - [ ] Adopt edgy-group.nvim
    - [ ] Adopt nvim-scissors
    - [ ] Adopt Obsidian.nvim
    - [ ] Adopt nvim-ufo
    - [ ] replace spectre with grug-far -> integrate in sidebar and trouble
    - [ ] Update gp.nvim configuration -> fix workflow. make it easier to toggle
      float, delete chats, and split mode integration with edgy
    - [ ] Go over all commands, check if enough are present
    - [ ] Streamline overseer.nvim integration with snacks.terminal (requires testing, heracles would be a good example)
    - [ ] Switch from possesion to resession
        - [ ] wrong tab being opened on restore (due to notify, neo-tree?)
            reproduce: knowledge-base, tab 1 (neo-tree, md), tab 2 (python, chatgpt)
        - [ ] Do not ask to save changes to "Neotest Output Panel" and "[dap-repl]"
        - [ ] Restore terminal with sessions
        - [ ] if no restore, then source venv if active
    - [ ] Overseer:
        - [ ] "OverseerQuickAction duplicate" would be convenient
        - [ ] OverseerSaveBundle opens input in seemingly random location
    - [ ] Replace targets.nvim and treesitter-textobjects with mini.ai and <swap plugin>

    - Projects per Tab:
    Quite some changes needed to make this work. Sessions opening/closing
    buffers would conflict.
        - [ ] Update Bufferline / Tabline
        - [ ] neotest: detach when switching projects / sessions
                neotest has no built-in method for doing this
- Bugs:
    - [ ] kitty settings are reverted when another neovim instance is opened
    - [ ] completion in cmdline closes after a few seconds / tabs

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

