- conform: make isort / pylint run async
- replace mason with my own checkhealth for missing dependencies
- resession but check that git commit status has not changed
- obsidian
- spectre / search-replace
- replace hydra with whichkey?
- configure wrapping properly (softwarp no point without textwidth)
- tailwind tools broken?

- test hlslens and textobj
- project.nvim, dashboard.nvim, session

- icons:
    - remove lualine filetype
    - telescope find all icons space
    - neo tree icons space

- scrollbar removed
- disable hint diagnostics
- molten not building

deprecated plugins?:
- sentiment.nvim (this should be covered by matchup)
- do I need ts-context-commentstring? (test with svelte)
- scrolleof (doesn't provide usefull functionality)

try out:
- cmp completion styling once colorscheme installed
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
