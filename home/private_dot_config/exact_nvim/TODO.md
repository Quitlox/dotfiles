
- [ ] Icons: add padding to treesitter
    - I tried overriding "telescope.utils".get_devicons, but it doesn't seem to work
- [ ] Session: Save neotree state (https://github.com/coffebar/neovim-project/blob/main/lua/neovim-project/utils/neo-tree.lua)
- [ ] Session: Save overseer state (https://github.com/stevearc/overseer.nvim/blob/master/doc/third_party.md#other-session-managers)
- [ ] Investigate: Slow Legendary, Iconpicker (or Telescope?)
- [ ] Statusline: Show git blame of current line?
- [ ] Report: profile.nvim bug

- [ ] Minor Improvements:
    - [ ] Python
        - [ ] Requirements checking and installation should be async
        - [ ] Pip may print lines to stdout
        - [ ] Erroneously reporting pynvim not installed ?

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
