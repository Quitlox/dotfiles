- replace mason with my own checkhealth for missing dependencies
- obsidian
- spectre / search-replace
- replace hydra with whichkey?
- configure wrapping properly (softwarp no point without textwidth)

- icons:
    - remove lualine filetype
    - telescope find all icons space

- scrollbar removed
- disable hint diagnostics
- molten not building
- when dab focusses the breakpoint, it should focus an existing window if
  possible, instead of opening the buffer in the current window

try out:
- diffview for reviewing pr

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
