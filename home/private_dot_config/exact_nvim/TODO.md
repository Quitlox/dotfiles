- Changes
    - [ ] when going to a definition outside of the cwd, open a new tab and set the tcd
    - [ ] Go over all commands, check if enough are present
    - [ ] Go over all plugins and use Snacks.on_module for integrations to prevent errors if module uninstalled
        - I need a shorthand for throwing an error if a module is not present,
          optionally with a message

    - [ ] Adopt remote-nvim.nvim
    - [X] Adopt Obsidian.nvim
    - [ ] Overseer:
        - [ ] "OverseerQuickAction duplicate" would be convenient
    - [ ] Cheatsheets:
        - [ ] Add cheatsheets for infrequently used workflows:
            - [ ] Markdown: Editing Tables
            - [ ] CSV: Viewing / Editing 
            - [ ] Molten: Python REPL
            - [ ] Infrequently used languages: Go / Rust

    - Projects per Tab:
        - [ ] Switch from possesion to resession
        - [ ] sessions: main problem is the integration with a session manager
            the session manager must handle tcd and only set the window layout of the current tab
            maybe I should instead move away from autoloading sessions
            I also have to stop depending on bufferline, as this interferes with
            the idea of using the tabline to switch between projects
        - [ ] neotest: detach when switching projects / sessions
                neotest has no built-in method for doing this
        - [ ] possession: wrong tab being opened on restore (due to notify, neo-tree?)
                reproduce: knowledge-base, tab 1 (neo-tree, md), tab 2 (python, chatgpt)
- Bugs:
    - [x] snacks.terminal: `<esc>` in lazygit unbound
    - [ ] venv-selector: doesn't work without python file open
    - [ ] dap-ui: enter and i should also open location in "Call Stack" window
    - [ ] dap-ui: repl icons background color wrong (should be darkest, as in edgy)
    - [ ] mini-ai: mapping `ci"` in python on final `"` goes to next
    - [ ] mini-ai: mapping `ci"` in python doesn't not respected in comments or docstrings 
    - [ ] gp.nvim: `<C-g>f` (find) opens selected chat in first window, should use window picker
    - [x] grug-far.nvim: cannot search on char `<` / `>` (https://github.com/MagicDuck/grug-far.nvim/issues/360)
    - [X] possesion: do not print when no session is found
    - [X] bug: searching to the next query with `n` doesn't work because of scrolling animation

- [ ] To Investigate
    - [ ] snacks.profile: investigate sluggishness when switching windows from
      terminal into LSP enabled window (python) -> its linting, but why
    - [ ] edgy: on open explorer, windows should be resized
    - [ ] pymple: not working, probably due to virtual environment
    - [ ] gp.nvim: floating window has margin that disappears in insert mode, which is annoying
    - [ ] keymap: `<leader>dt` seems to be bound to something else

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

