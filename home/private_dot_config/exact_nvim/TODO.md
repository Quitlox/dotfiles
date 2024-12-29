- Changes
    - [ ] Adopt remote-nvim.nvim
    - [ ] Adopt Obsidian.nvim
    - [ ] Go over all commands, check if enough are present
    - [ ] Streamline overseer.nvim integration with snacks.terminal (requires testing, heracles would be a good example)
    - [ ] Switch from possesion to resession
        - [ ] wrong tab being opened on restore (due to notify, neo-tree?)
            reproduce: knowledge-base, tab 1 (neo-tree, md), tab 2 (python, chatgpt)
        - [ ] Do not ask to save changes to "Neotest Output Panel" and "[dap-repl]"
        - [ ] Restore terminal with sessions
        - [x] if no restore, then source venv if active
    - [ ] Overseer:
        - [ ] "OverseerQuickAction duplicate" would be convenient
        - [ ] OverseerSaveBundle opens input in seemingly random location
    - [ ] Replace targets.nvim and treesitter-textobjects with mini.ai and <swap plugin>

    - Projects per Tab:
        - [ ] sessions: main problem is the integration with a session manager
            the session manager must handle tcd and only set the window layout of the current tab
            maybe I should instead move away from autoloading sessions
            I also have to stop depending on bufferline, as this interferes with
            the idea of using the tabline to switch between projects
        - [ ] neotest: detach when switching projects / sessions
                neotest has no built-in method for doing this
- Bugs:

- [ ] To Investigate
    - [ ] dap-ui: "DAP Watches" shows up as listed buffer in bufferline if edited
    - [ ] snacks.profile: investigate sluggishness when switching windows from
      terminal into LSP enabled window (python)
- Requires Contribution:
    - [ ] overseer: map <esc> in help_win (not configurable currently)
    - [ ] treewalker.nvim: allow skipping certain nodes
    - [ ] treewalker.nvim: automatically disable in buffers without parsers/lang
    - [ ] rocks.nvim: provide warning for outdated plugins (both scm vs git and pin vs scm)

Desktop:
- [ ] Eww: Bar should use fill icons on select
- [ ] Hypr: Configure coding workspace with auto-centered neovide?


### Memorandum
- Help File Navigation: Hit `gO` to open an outline in the help file.
- In insert mode, use `<C-o>` to execute a normal mode command.

