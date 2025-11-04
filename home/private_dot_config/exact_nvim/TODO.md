- Features

  - [ ] When going to a definition outside of the cwd, open a new tab and set the tcd
  - [ ] Add cheatsheets for infrequently used workflows:
    - [ ] Markdown: Editing Tables
    - [ ] CSV: Viewing / Editing
    - [ ] Kulala
    - NVIM TIPS PLUGIN FOR CHEATS?!
  - [ ] Which-Key:
    - [ ] once which-key supports custom highlights per mapping, I should pimp it ('default' mappings should be grayed)

- To Investigate:
  - modify path popup is a picker, which is annoying. It should be a yes/no

  - go over python.nvim mappings

  - i need a hydra mode for git staging
  - ripgrep through help

  - snacks.nvim gives popup with exit-code for normal terminals, which is not
  convenient as the exit code of the terminal will be the exit code of the last
  command ran

  - [ ] `edgy.nvim`: does not resize windows on restore of session, e.g. help window.
        Hard-to-fix. Tried using AI to fix it, but it didn't work.
  - [ ] `matchup`: unwelcome matching of `[` in strings
  ```lua
  require("which-key").add({
      { "[%", desc = "Prev Match" },
      { "]%", desc = "Next Match" },
  })
  ```
  - [ ] `flash.nvim`: incremental selection (https://github.com/folke/flash.nvim/commit/59fc862d43dba249456c93c70ebabfa460c9db84)

  - tabs are ugly right now and I don't want the tab number in the middle of the bar
  - ideally, in python, folds would fold entire function definitions, not parameters seperately  
  - do not active python lsp/conform before virtual env ?
  - make "daa" (delete around argument) also delete function parameters in func def (in python)
      - more specifically, the issue is if the type has brackets, that takes precendence
  - [ ] very specific python indentation behaviour:
    - [ ] related issue: when double enter in insert mode, it should fallback an indention level
  ```python
  class MpycFunction(Function):

      def _spawn_party_process_with_streaming(
          self, party_id: int, n_parties: int, temp_dir: Path
      ) -> subprocess.Popen:
          ...

          def subprocess_logger(pipe: IO[bytes]):
              with pipe:
                  for line in iter(pipe.readline, b""):
                      self.stash[MPYC_LOG_KEY].append(line.decode("ascii").strip())
                      # 2. cursor jumps to this indentation level

          # 1. <cursor here> press <C-S-O>
          thread = Thread(target=subprocess_logger, args=(process.stdout,), daemon=True)
          thread.start()
  ```

- Requires Contribution:

  - [ ] overseer: background tasks should not be awaited for completion
  - [ ] snacks.picker: `select_up` at index 0 doesn't go to the last item
  - [ ] `scissors.nvim`: add option to toggle autosnippet

  - [ ] nvim-dap-ui: closing dap with editor splits sets winfixwidth, causing the windows not to resize properly
    - https://github.com/rcarriga/nvim-dap-ui/issues/175
    - https://github.com/rcarriga/nvim-dap-ui/issues/260
  - [ ] nvim-dap-ui: watches window should allow delete on partial line (with ">")

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

- Contribute back, sane defaults, low priority:
  - [ ] overseer.nvim: task view has not filetype
  - [ ] overseer.nvim: my custom dispose_all, restart_all commands
  - [ ] nvim-treesitter-textobjects / mini.ai: python @string.inner / @string.outer
        I would need to find a way around the "@string.inner" problem

When need arises:

- [molten.nvim] for Python REPL / Jupyter Notebook
- [remote-nvim.nvim] when working on remote machines.
- replacements:
  - [ ] `nvzone/floatterm` -> pretty cool way of managing terminals. I currently
    stuggle with managing multiple terminals..
  - [ ] `rachartier/tiny-code-action.nvim` -> nicer code action?
  supports both preview and quick keybindings.
- language-specific:
  - [ ] web: colortils.nvim (replacement of colorizer)
  - [ ] enable `textDocument/documentColor`
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

