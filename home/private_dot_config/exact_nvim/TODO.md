- Features

  - [ ] When going to a definition outside of the cwd, open a new tab and set the tcd
  - [ ] Add cheatsheets for infrequently used workflows:
    - [ ] Markdown: Editing Tables
    - [ ] CSV: Viewing / Editing
    - [ ] Kulala
  - [ ] Learning:
    - [ ] Read about jumplist
    - [ ] Read about default mappings (index.txt), especially % g% g[ [(
  - [ ] Which-Key:
    - [ ] once which-key supports custom highlights per mapping, I should pimp it ('default' mappings should be grayed)

- To Change / Bugs:

  - [ ] `snacks.notifier`: The help notification of `<leader>sa` (scissors) is ellipsed, but it should be wrapped.
  - [ ] adopt mason?

- To Investigate:

  - [ ] snacks.profile: investigate sluggishness when switching windows from
        terminal into LSP enabled window (python) -> its linting, but why
  - [ ] `snacks.picker`: `lsp_workspace_symbols` sorting is not good
        in `tno.mpc.communication`, searching for `Pool` does not retrieve the `Pool` class
  - [ ] `edgy.nvim`: does not resize windows on restore of session, e.g. help window
        hard-to-fix. Tried using AI to fix it, but it didn't work.
  - [ ] `snacks.notifier`: The help notification of `<leader>sa` (scissors) is ellipsed, but it should be wrapped.

- Requires Contribution:

  - [ ] aerial: improve keymap window (group related mappings, remove duplicates)
  - [ ] overseer: map <esc> in help_win (not configurable currently)
  - [ ] overseer: background tasks should not be awaited for completion
  - [ ] overseer: add option to not autorestart isBackground tasks
  - [ ] navic: doesn't work with arrow, same context in all windows
  - [ ] navic: should provide symbol filter, but maintainer is inactive
  - [ ] snacks.picker: `select_up` at index 0 doesn't go to the last item
  - [ ] `scissors.nvim`: add option to toggle autosnippet
  - [ ] markview.nvim: add `\mod` and `\bmod` symbols (I have no clue how to add new symbols)
  - [ ] venv-selector: doesn't work without python file open

  - [ ] nvim-dap-ui: closing dap with editor splits sets winfixwidth, causing the windows not to resize properly
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
    - sometimes gets stuck in toggling the breakpoint. It seems as if it's
      waiting for another key, but there are no duplicate mappings.
  - [ ] pymple: just refuses to work
    - it finds seemingly correct candidates for imports, but then doesn't pick one
  - [ ] neotest:
    - tab-scoped: should support multiple tabs, and attaching/detaching from cwd's
  - [ ] `venv-selector.nvim`: switch out with `joshzcold/python.nvim` once mature (and supporting `uv`)

- Contribute back, sane defaults, low priority:
  - [ ] overseer.nvim: task view has not filetype
  - [ ] overseer.nvim: my custom dispose_all, restart_all commands
  - [ ] nvim-treesitter-textobjects / mini.ai: python @string.inner / @string.outer
        I would need to find a way around the "@string.inner" problem

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
- Use 'g==' to execute a block of code (or a terminal escape sequence).

_Resources_

- cheat.sh
- devdocs.io
