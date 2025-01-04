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
- Bugs:
    - [ ] dap: cmp integration
    - [ ] possession: wrong tab being opened on restore (due to notify, neo-tree?)
            reproduce: knowledge-base, tab 1 (neo-tree, md), tab 2 (python, chatgpt)

- [ ] To Investigate
    - [ ] snacks.profile: investigate sluggishness when switching windows from
      terminal into LSP enabled window (python)
    - [ ] which-key: add description to mini.ai
    - [ ] edgy: on open explorer, windows should be resized
    - [ ] mini.ai: in python ci" should also capture f-strings
    - [ ] mini.ai: no query for lua functions?
    - [ ] pymple: not working, probably due to virtual environment

- Requires Contribution:
    - [ ] treewalker.nvim: allow skipping certain nodes
    - [ ] treewalker.nvim: automatically disable in buffers without parsers/lang
    - [ ] rocks.nvim: provide warning for outdated plugins (both scm vs git and pin vs scm)
    - [ ] navic: should provide symbol filter, but maintainer is inactive
    - [ ] overseer: map <esc> in help_win (not configurable currently)
    - [ ] overseer: jk should move to job in OverseerTaskList, not step around
    - [ ] overseer: attach debugger
    - [ ] overseer: term should scroll to bottom automatically
    - [ ] overseer: background tasks should not be awaited for completion
    - [x] blink.cmp: the char / should be a trigger for the path source
    - [ ] navic: doesn't work with arrow, same context in all windows
    - [ ] rocks:
        - [ ] should not update git to older version tag if ver is specified to be a newer commit
        - [ ] toml-edit should keep inline items as inline
        - [ ] toml edit should not move the comments  
    - [ ] blink.cmp: rewrite cmp-dap for blink.cmp. (it's quite a small plugin) 


- Requires Contribution (hard-to-fix):
    - [ ] nvim: <BS> and <C-BS> have odd behaviour in DAP REPL and DAP Watches
        - https://github.com/rcarriga/nvim-dap-ui/issues/31
        - https://github.com/neovim/neovim/issues/14116
    - [ ] neovide: misalignment character rendered in lualine (powershell symbol)
        - https://github.com/neovide/neovide/issues/2491
    - [ ] resession: plugin for restoring shell contents
        should be doable?

- Contribute, sane defaults, low priority:
    - [ ] overseer.nvim: task view has not filetype
    - [ ] overseer.nvim: my custom dispose_all, restart_all commands

Desktop:
- [ ] Eww: Bar should use fill icons on select
- [ ] Hypr: Configure coding workspace with auto-centered neovide?


### Memorandum
- Help File Navigation: Hit `gO` to open an outline in the help file.
- In insert mode, use `<C-o>` to execute a normal mode command.

