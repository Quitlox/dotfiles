- Features

  - [ ] When going to a definition outside of the cwd, open a new tab and set the tcd
  - [ ] Add cheatsheets for infrequently used workflows:
    - [ ] Markdown: Editing Tables
    - [ ] CSV: Viewing / Editing
    - [ ] Kulala
  - [ ] Which-Key:
    - [ ] once which-key supports custom highlights per mapping, I should pimp it ('default' mappings should be grayed)

- To Investigate:

  - [ ] replace `arrow.nvim`: 
    - I don't quite like `arrow.nvim`. I should really pay attention to how I would like to use "file/buffer bookmarks". It could be worth to try `recall.nvim` + `marks.nvim`.

  - [ ] `edgy.nvim`: does not resize windows on restore of session, e.g. help window
        hard-to-fix. Tried using AI to fix it, but it didn't work.
  - [ ] `edgy.nvim` when opening right sidebar, vsplits are not sized properly
  - [ ] `snacks.scroll?`: navigating to a next diagnostic (`]d`) does not show popup if the window is scrolled


  - [ ] `matchup`: unwelcome matching of `[` in strings
```lua
require("which-key").add({
    { "[%", desc = "Prev Match" },
    { "]%", desc = "Next Match" },
})
```

- Requires Contribution:

  - [ ] overseer: background tasks should not be awaited for completion
  - [ ] navic: doesn't work with arrow, same context in all windows
  - [ ] snacks.picker: `select_up` at index 0 doesn't go to the last item
  - [ ] `scissors.nvim`: add option to toggle autosnippet

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

  - [ ] `aerial.nvim`: improve keymap window (group related mappings, remove duplicates)
      - https://github.com/stevearc/aerial.nvim/pull/469
  - [ ] overseer: (will be refactored)
      - [ ] overseer: map <esc> in help_win (not configurable currently)
  - [ ] rocks.nvim: (awaiting lux)
    - [ ] provide warning for outdated plugins (both scm vs git and pin vs scm)
    - [ ] should not update git to older version tag if ver is specified to be a newer commit
    - [ ] toml-edit should keep inline items as inline
    - [ ] toml-edit should not move the comments
  - [ ] dap.nvim: 
    - [ ] I can't for the life of me figure it out, but `<leader>dt`
      sometimes gets stuck in toggling the breakpoint. It seems as if it's
      waiting for another key, but there are no duplicate mappings.

- Contribute back, sane defaults, low priority:
  - [ ] overseer.nvim: task view has not filetype
  - [ ] overseer.nvim: my custom dispose_all, restart_all commands
  - [ ] nvim-treesitter-textobjects / mini.ai: python @string.inner / @string.outer
        I would need to find a way around the "@string.inner" problem

When need arises:

- [molten.nvim] for Python REPL / Jupyter Notebook
- [remote-nvim.nvim] when working on remote machines.
- language-spectic:
  - [ ] web: colortils.nvim (replacement of colorizer)
  - [ ] enable `textDocument/documentColor`
    - https://github.com/neovim/neovim/pull/33440
- `smart-motion.nvim`: flexible and extensible motion plugin, but I am satisfied with flash
- optional plugins:
  - `nvim-scrollbar`: not very necessary, but very well maintained

Desktop:
- [ ] Eww: Bar use fill icons on select

Plugin Ideas:
    - Rewrite of neotest:
        - support both simple configuration through cli and advanced configuration through adapter
        - streaming of results
        - automatic detection of test framework
        - more consistent interface
    - VimTex for Neovim / TexLab plugin
        - Provide extensions for many popular plugins (i.e. mini.ai for textobjects)
        - Provide automatic setup of TexLab
    - Python for Neovim
        - More comprehensive support for Python development
        - support virtual envs robustly
            - auto detect virtual envs. 
            - auto-activate (if one found in shell, or if only one in project)
            - set venv per tab / project root
            - inform lsp server
            - (maybe I should track virtualenvs per buffer, like attaching lsps to buffers)
        - provide library functions
        - integrate with mason
    - Extend `neoconf` to handle formatters/linters/debuggers/testers
    - Custom Outline plugin
        - Harpoon, but for symbols
        - Easily add symbols all over your project to an outline for easy navigation
    - Extend `overseer.nvim` to support generation of `launch.json` files

### Memorandum

- In insert mode, use `<C-o>` to execute a normal mode command.
- Use 'g==' to execute a block of code (or a terminal escape sequence).
- `vim.keymap.set("n", "ycc", "yygccp", { remap = true }) -- copy and comment`
- `vim.keymap.set("i", ",,", "A,<ESC>")`

_Resources_

- cheat.sh
- devdocs.io
