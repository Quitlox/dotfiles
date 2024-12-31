- Changes
    - [ ] when going to a definition outside of the cwd, open a new tab and set the tcd
    - [ ] Go over all commands, check if enough are present
    - [ ] Go over all plugins and contribute sane defaults
    - [ ] Go over all plugins and use Snacks.on_module for integrations to prevent errors if module uninstalled
        - I need a shorthand for throwing an error if a module is not present,
          optionally with a message

    - [ ] todo app for keeping track of what the fuck im doing in a repo
    - [ ] Adopt remote-nvim.nvim
    - [ ] Adopt Obsidian.nvim
    - [ ] Switch from possesion to resession
        - [ ] wrong tab being opened on restore (due to notify, neo-tree?)
            reproduce: knowledge-base, tab 1 (neo-tree, md), tab 2 (python, chatgpt)
        - [ ] Do not ask to save changes to "Neotest Output Panel" and "[dap-repl]"
        - [ ] Restore terminal with sessions
    - [ ] Overseer:
        - [ ] "OverseerQuickAction duplicate" would be convenient
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
    - [ ] jump <C-o> no longer works, ends up at wrong location, probably due to Snacks.scroll? it ends up at center of screen
    - [ ] keymap: <leader>bo remove dependency on bufferline
    - [ ] nvim: there is some plugin that is printing the filename upon opening a file which is annoying

    - [ ] error when pasting lua code from gp.lua float into lua buffer. error thrown by lazydev?
```log
vim/_editor.lua:0: nvim_exec2(): Vim(normal):Error executing lua callback: ...ox/.local/share/nvim/rocks/rocks_rtp/lua/lazydev/buf.lua:143: attempt to index local 'ws' (a nil value)
stack traceback:
	...ox/.local/share/nvim/rocks/rocks_rtp/lua/lazydev/buf.lua:143: in function 'on_mod'
	...ox/.local/share/nvim/rocks/rocks_rtp/lua/lazydev/buf.lua:109: in function 'on_line'
	...ox/.local/share/nvim/rocks/rocks_rtp/lua/lazydev/buf.lua:93: in function 'on_lines'
	...ox/.local/share/nvim/rocks/rocks_rtp/lua/lazydev/buf.lua:71: in function <...ox/.local/share/nvim/rocks/rocks_rtp/lua/lazydev/buf.lua:70>
	[C]: in function 'nvim_exec2'
	vim/_editor.lua: in function <vim/_editor.lua:0>
	[C]: in function 'pcall'
	...hare/nvim/site/pack/rocks/start/yanky.nvim/lua/yanky.lua:73: in function 'callback'
	...hare/nvim/site/pack/rocks/start/yanky.nvim/lua/yanky.lua:164: in function 'init_ring'
	...hare/nvim/site/pack/rocks/start/yanky.nvim/lua/yanky.lua:113: in function 'put'
	...hare/nvim/site/pack/rocks/start/yanky.nvim/lua/yanky.lua:320: in function <...hare/nvim/site/pack/rocks/start/yanky.nvim/lua/yanky.lua:319>
```

- [ ] To Investigate
    - [ ] snacks.profile: investigate sluggishness when switching windows from
      terminal into LSP enabled window (python)
    - [ ] which-key: add description to mini.ai
    - [ ] edgy: on open explorer, windows should be resized
    - [ ] mini.ai: in python ci" should also capture f-strings
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
    - [ ] blink.cmp: the char / should be a trigger for the path source
    - [ ] navic: doesn't work with arrow, same context in all windows

- Requires Contribution (hard-to-fix):
    - [ ] nvim: <BS> and <C-BS> have odd behaviour in DAP REPL and DAP Watches
        - https://github.com/rcarriga/nvim-dap-ui/issues/31
        - https://github.com/neovim/neovim/issues/14116
    - [ ] neovide: misalignment character rendered in lualine (powershell symbol)
        - https://github.com/neovide/neovide/issues/2491

- Contribute, sane defaults, low priority:
    - [ ] overseer.nvim: task view has not filetype
    - [ ] overseer.nvim: my custom dispose_all, restart_all commands

Desktop:
- [ ] Eww: Bar should use fill icons on select
- [ ] Hypr: Configure coding workspace with auto-centered neovide?


### Memorandum
- Help File Navigation: Hit `gO` to open an outline in the help file.
- In insert mode, use `<C-o>` to execute a normal mode command.

