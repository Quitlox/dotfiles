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
    - [x] lualine: winbar filename icon shouldn't disappear when inactive
    - [ ] lualine: when inactive: background color of section y should stay the same
    - [x] venv-selector: after activate, restart LSPs
    - [x] checkhealth: python3 provider not loading
    - [x] textobjects / targets: da[ is mapped twice
    - [x] textobjects: daC in Python doesn't capture decorator
    - [x] targets: da is mapped twice
    - [x] why does "gw" wrap parentheses weird?
    - [x] replace todo-comments gutter signs with codicons
    - [ ] jump <C-o> no longer works, ends up at wrong location, probably due to Snacks.scroll? it ends up at center of screen
    - [ ] navic: doesn't work with arrow, same context in all windows
    - [ ] keymap: <C-w>\= is broken
    - [ ] keymap: "q" should close gp.lua
    - [ ] keymap: <leader>e mapping broken
    - [ ] possession: auto source venv broken again
    - [x] possession: not loading
    - [ ] possession: PossessionSaveCwd not using cwd...
    - [ ] overseer.nvim: contribute set ft on task buffer
    - [ ] overseer.nvim: RunCmd path completion is shitty
    - [ ] overseer: intergration still broke
    - [ ] overseer: introduce mapping for RunCmd
    - [ ] overseer: duplicate
    - [ ] overseer: possession not being saved
    - [ ] dap.nvim: <C-bs> doesn't work in watches
    - [ ] dap.nvim: automatically close overseer
    - [x] targets: va<Esc> should cancel entering visual mode
    - [ ] print: statements made by edgy and wrapping.nvim are annoying
    - [ ] nvim-dap-repl-highlights: requires parser installation
    - [ ] nvim: after pasting, the cursor should stay in the same column
    - [x] blink.cmp: slash / should be a preconfigured trigger character in blink path source
    - [x] treesitter-context: should have a maximum
    - [ ] neovide: misalignment character rendered in lualine (powershell symbol)
    - [ ] tiny-inline-diagnostic: not a good option
    - [ ] pymple: not working
    - [ ] win: on <C-j>always to to bottom leftmost window (esp when overseer is open)

    - [ ] overseer: when entering normal command "ca" in editor, overseer throws:
```log
Error detected while processing function targets#e[10]..User Autocommands for "OverseerListUpdate":                                                                                                                                                  
Error executing lua callback: .../nvim/rocks/rocks_rtp/lua/overseer/task_list/sidebar.lua:411: E565: Not allowed to change text or change window                                                                                                     
stack traceback:                                                                                                                                                                                                                                     
    [C]: in function 'nvim_buf_set_lines'                                                                                                                                                                                                        
    .../nvim/rocks/rocks_rtp/lua/overseer/task_list/sidebar.lua:411: in function 'render'                                                                                                                                                        
    .../nvim/rocks/rocks_rtp/lua/overseer/task_list/sidebar.lua:84: in function <.../nvim/rocks/rocks_rtp/lua/overseer/task_list/sidebar.lua:83>                                                                                                 
    [C]: in function 'nvim_exec_autocmds'                                                                                                                                                                                                        
    ...are/nvim/rocks/rocks_rtp/lua/overseer/task_list/init.lua:14: in function 'rerender'                                                                                                                                                       
    ...ks/rocks_rtp/lua/overseer/component/display_duration.lua:34: in function ''                                                                                                                                                               
    vim/_editor.lua: in function <vim/_editor.lua:0>  
```

    - [ ] error when pasting lua code from gp.lua float into lua buffer. error
      thrown by lazydev?
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
    - [ ] dap-ui: "DAP Watches" shows up as listed buffer in bufferline if edited
    - [ ] snacks.profile: investigate sluggishness when switching windows from
      terminal into LSP enabled window (python)
    - [ ] which-key: add description to mini.ai
    - [ ] edgy: on open explorer, windows should be resized
    - [ ] mini.ai: in python ci" should also capture f-strings
- Requires Contribution:
    - [ ] overseer: map <esc> in help_win (not configurable currently)
    - [ ] treewalker.nvim: allow skipping certain nodes
    - [ ] treewalker.nvim: automatically disable in buffers without parsers/lang
    - [ ] rocks.nvim: provide warning for outdated plugins (both scm vs git and pin vs scm)
    - [ ] navic: should provide symbol filter, but maintainer is inactive
    - [ ] overseer: jk should move to job in OverseerTaskList, not step around
    - [ ] overseer: attach debugger
    - [ ] overseer: term should scroll to bottom automatically
    - [ ] blink.cmp: the char / should be a trigger for the path source

Desktop:
- [ ] Eww: Bar should use fill icons on select
- [ ] Hypr: Configure coding workspace with auto-centered neovide?


### Memorandum
- Help File Navigation: Hit `gO` to open an outline in the help file.
- In insert mode, use `<C-o>` to execute a normal mode command.

