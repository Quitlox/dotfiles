- Features
    - [ ] When going to a definition outside of the cwd, open a new tab and set the tcd
    - [ ] Add cheatsheets for infrequently used workflows:
        - [ ] Markdown: Editing Tables
        - [ ] CSV: Viewing / Editing 

- To Change / Bugs:
    - [ ] venv-selector: doesn't work without python file open
    - [ ] gp.nvim: `<C-g>f` (find) opens selected chat in first window, should use window picker
    - [X] toggle: fix toggle of buffer local formatting
    - [ ] ultimate-autopairs: switch to this plugin, as it support multiline and wrapping of nodes
    - [ ] configure `@parameter` in yaml as sibling node
    - [ ] add `vectorcode.nvim`
    - [ ] add `aerial.nvim`
    - [X] `oil.nvim`: Deleting a file should close its attached buffer
    - [ ] neotest: detach when switching projects / sessions neotest has no built-in method for doing this
    - [ ] replace `workspaces.nvim`

- [ ] To Investigate
    - [ ] snacks.profile: investigate sluggishness when switching windows from
      terminal into LSP enabled window (python) -> its linting, but why
    - [X] edgy: on open explorer, windows should be resized
    - [ ] gp.nvim: floating window has margin that disappears in insert mode, which is annoying
    - [ ] mini-ai: mapping `ca"` in python on final `"` goes to next
        This is due to my custom text object. But it may still be a bug in mini-ai, as it seems my text object is correct
        This would also be solved if I could only map `ca` and not `ci`, but this doesn't seem possible.
    - [ ] mini-ai: mapping `ca"` in python doesn't not respected in comments or docstrings 
        This is unfortunately also a consequence of my custom text object, as strings in comments are not recognized as strings.

- Requires Contribution:
    - [ ] workspaces.nvim: create `snacks.picker` based picker
    - [ ] treewalker.nvim: allow skipping certain nodes
    - [ ] treesj: join should look for parent nodes
    - [ ] overseer: map <esc> in help_win (not configurable currently)
    - [ ] overseer: jk should move to job in OverseerTaskList, not step around
    - [ ] overseer: background tasks should not be awaited for completion
    - [ ] overseer: add option to not autorestart isBackground tasks 
    - [x] blink.cmp: the char / should be a trigger for the path source
    - [ ] blink.cmp: it seems that the `trailing_slash` option of the path source doesn't listen in cmdline mode
    - [ ] navic: doesn't work with arrow, same context in all windows
    - [ ] navic: should provide symbol filter, but maintainer is inactive
    - [ ] snacks.picker: `select_up` at index 0 doesn't go to the last item
    - [ ] markview.nvim: add `\mod` and `\bmod` symbols (I have no clue how to add new symbols)

    - [ ] nvim-dap-ui: closing dap with editor splits sets winfixwidth, causing
      the windows not to resize properly
        - https://github.com/rcarriga/nvim-dap-ui/issues/175
        - https://github.com/rcarriga/nvim-dap-ui/issues/260
    - [ ] nvim-dap-ui / overseer: after using debugging, the mappings over the
        overseer window are no longer available (or its because cannot make changes,
        'modifiable' is off)
    - [ ] nvim-dap-ui: on second debug session, repl is not available
        there is a repl window, but it has the generic name "dap-repl-198" and
        doesn't show anything.
    - [ ] nvim-dap-ui: watches window should allow delete on partial line (with ">")

- Requires Contribution (hard-to-fix):
    - [ ] resession: plugin for restoring shell contents
    - [ ] blink.cmp: rewrite cmp-dap for blink.cmp. (it's quite a small plugin) 
    - [ ] hover.nvim: allow changing priority of providers (https://github.com/lewis6991/hover.nvim/issues/77)

- Blocked:
    - [ ] rocks.nvim: rocks related issues should wait for lux
        - [ ] provide warning for outdated plugins (both scm vs git and pin vs scm)
        - [ ] should not update git to older version tag if ver is specified to be a newer commit
        - [ ] toml-edit should keep inline items as inline
        - [ ] toml-edit should not move the comments  
    - [ ] neovide: misalignment character rendered in lualine (powershell symbol)
        - https://github.com/neovide/neovide/issues/2491
    - [ ] dap.nvim: I can't for the life of me figure it out, but `<leader>dt`
    sometimes gets stuck in toggling the breakpoint. It seems as if it's waiting
    for another key, but there are no duplicate mappings.
    - [ ] pymple: just refuses to work
        - it finds seemingly correct candidates for imports, but then doesn't pick one

- Contribute back, sane defaults, low priority:
    - [ ] overseer.nvim: task view has not filetype
    - [ ] overseer.nvim: my custom dispose_all, restart_all commands
    - [ ] nvim-treesitter-textobjects / mini.ai: python @string.inner / @string.outer

When need arises:
- [molten.nvim] for Python REPL / Jupyter Notebook
- [remote-nvim.nvim] when working on remote machines.
- language-spectic:
    - web: colortils.nvim (replacement of colorizer)

Desktop:
- [ ] Eww: Bar should use fill icons on select
- [ ] Hypr: Configure coding workspace with auto-centered neovide?
- [ ] Chezmoi:
    - [ ] `~/Documents/PowerShell` should only be created on Windows
    - [ ] `~/.mozilla` script should not run in headless mode


### Memorandum
- Help File Navigation: Hit `gO` to open an outline in the help file.
- In insert mode, use `<C-o>` to execute a normal mode command.

