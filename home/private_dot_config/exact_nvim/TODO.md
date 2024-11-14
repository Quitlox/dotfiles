
- [ ] Icons: add padding to telescope
    - I tried overriding "telescope.utils".get_devicons, but it doesn't seem to work
- [x] Session: Save neotree state (https://github.com/coffebar/neovim-project/blob/main/lua/neovim-project/utils/neo-tree.lua)
- [x] Session: Save overseer state (https://github.com/stevearc/overseer.nvim/blob/master/doc/third_party.md#other-session-managers)
- [x] Investigate: Slow Legendary, Iconpicker (or Telescope?)
- [x] Statusline: Show git blame of current line?
- [ ] Report: profile.nvim bug
- [x] Keybinding: Select git branch
- [ ] LSP Diagnostics: Currently not very useful for Python in Trouble mode
- [ ] Possession Bugs: 
    - Do not ask to save changes to "Neotest Output Panel" and "[dap-repl]"
    - Keeps opening COMMIT_MSG for some reason
    - Neotest gets angry after switching
- [ ] DapUI: "DAP Watches" shows up as listed buffer in bufferline if edited
- [ ] Automatically optimize on opening large file buffer
    - Disable LSP, Highlight, diagnostics
- [ ] Fix virtualenv selector
- [ ] Eww: Bar should use fill icons on select
- [ ] Overseer: 
    - [ ] "OverseerQuickAction duplicate" would be convenient
    - [ ] Keybinding <Esc> should close help window
    - [ ] Keybinding X to stop all
    - [ ] Keybinding <leader>e (without waiting for which-key) does not work
    - [ ] OverseerSaveBundle opens input in seemingly random location
- [ ] Glance.nvim:
    - [ ] Bug when having hlslens open (search highlights)

### Bugs

report bug: if treesitter-ecma is not installed explicitely, treesitter is not
autostarted

report bug: make one mistake in big config, is very confusing. My example, I had 
autopairs on ft InsertEnter with the following in cmp.
```lua
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
})
```

### Memorandum
- Help File Navigation: Hit `gO` to open an outline in the help file.
- In insert mode, use `<C-o>` to execute a normal mode command.


### Scratchpad

hyptoheses:
- it breaks when there is a large upgrade 
- it also added new revs to all git thingies, which might have something to do with it.
- the result broke my toml due to the comment thing


also:
- rocks refuses to install a branch
`Rocks install linux-cultist/venv-selector.nvim branch=regexp`


[credential "https://ci.tno.nl"]
	provider = generic
