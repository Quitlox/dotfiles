- Features
  - [ ] When going to a definition outside of the cwd, open a new tab and set the tcd

- To Investigate:
  - `overseer.nvim`: clone task (should be possible with serialize)
  - `python`: indentation level should dedent upon each blank new-line
  - `mini.ai`: mapping `val` doesn't work quickly (only slowly after `va`)

  - upon "gA" or session restore, we should trigger to load python.nvim
  - only show path source after cd/tcd in blink
  - show path in normal buffer also after slash

  - modify path popup is a picker, which is annoying. It should be a yes/no
  - i need a hydra mode for git staging

  - `%` on `<` does not seem to work in rust (matchup)

- Requires Contribution:
  - [ ] `scissors.nvim`: add option to toggle autosnippet
  - [ ] `nvim-dap-ui`: closing dap with editor splits sets winfixwidth, causing the windows not to resize properly
    - https://github.com/rcarriga/nvim-dap-ui/issues/175
    - https://github.com/rcarriga/nvim-dap-ui/issues/260
  - [ ] `nvim-dap-ui`: watches window should allow delete on partial line (with ">")

- Blocked:
  - [ ] `aerial.nvim`: improve keymap window (group related mappings, remove duplicates)
      - https://github.com/stevearc/aerial.nvim/pull/469
  - [ ] `overseer.nvim`: (will be refactored)
      - [ ] overseer: map <esc> in help_win (not configurable currently)
  - [ ] `rocks.nvim`: (awaiting lux)
    - [ ] provide warning for outdated plugins (both scm vs git and pin vs scm)
    - [ ] should not update git to older version tag if ver is specified to be a newer commit
    - [ ] toml-edit should keep inline items as inline
    - [ ] toml-edit should not move the comments
  - [ ] `dap.nvim`: 
    - [ ] I can't for the life of me figure it out, but `<leader>dt`
      sometimes gets stuck in toggling the breakpoint. It seems as if it's
      waiting for another key, but there are no duplicate mappings.
  - [ ] `neoconf.nvim`: broken as of lspconfig v2
  - [ ] `which-key.nvim`: if support for custom highlights is added,
    I should configure default mappings with a dimmed highlight

- Contribute back, sane defaults, low priority:
  - [ ] overseer.nvim: task view has not filetype
  - [ ] overseer.nvim: my custom dispose_all, restart_all commands
  - [ ] nvim-treesitter-textobjects / mini.ai: python @string.inner / @string.outer
        I would need to find a way around the "@string.inner" problem

Plugins I keep forgetting to use:
- `debugprint`: use `g?` for printing
- `mini.ai`: 
  - use textobjects:`l` for statement, `o` for block, `i` for indent, `s` for subword, `u` for function call
  - use `g[<object>` and `g]<object>` to navigate to start/end of textobject
- `treewalker.nvim`:
  - Use `<A-h/j/k/l>` for navigation
  - Use `g + h/j/k/l` for swaps


When need arises:
- [codesettings.nvim](https://github.com/mrjones2014/codesettings.nvim): replacement of `neoconf.nvim`
- [molten.nvim] for Python REPL / Jupyter Notebook
- [remote-nvim.nvim] when working on remote machines.
- replacements:
  -  `nvzone/floatterm` -> pretty cool way of managing terminals. I currently
    stuggle with managing multiple terminals..
  -  `rachartier/tiny-code-action.nvim` -> nicer code action?
  supports both preview and quick keybindings.
- language-specific:
  -  web: colortils.nvim (replacement of colorizer)
  -  enable `textDocument/documentColor`
    - https://github.com/neovim/neovim/pull/33440
- `smart-motion.nvim`: flexible and extensible motion plugin, but I am satisfied with flash
- better marks: `recall.nvim` + `marks.nvim` (harpoon/grapple/arrow-like solution?)
- instead of `snacks.nvim` home-rolled projects picker: https://github.com/DrKJeff16/project.nvim
- optional plugins:
  - `nvim-scrollbar`: not very necessary, but well maintained
  - `overlook.nvim`: cool idea (editable, stackable popups) for browsing code
  hiearchies, but built-in `<C-i>` and `<C-o>` should suffice.

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
    - Add extension to `resession.nvim`: extension for restoring shell contents

### Stuff I can do

- Nix: 
  - Home Manager
  - Package Servarr better
  - help rocks.nvim development


### Memorandum

- In insert mode, use `<C-o>` to execute a normal mode command.
- Use 'g==' to execute a block of code (or a terminal escape sequence).
- `vim.keymap.set("n", "ycc", "yygccp", { remap = true }) -- copy and comment`
- `vim.keymap.set("i", ",,", "A,<ESC>")`

_Resources_

- cheat.sh
- devdocs.io

