local ok = true
ok, _ = pcall(require, "mini.ai")
ok, _ = pcall(require, "nvim-treesitter.configs")
if not ok then
    return
end

require("nvim-treesitter.configs").setup({
    textobjects = {
        move = {
            goto_next_start = {
                ["]m"] = "@function.name",
                ["]f"] = "@function.name",
                ["]]"] = "@class.name",
            },
            goto_previous_start = {
                ["[m"] = "@function.name",
                ["[f"] = "@function.name",
                ["[["] = "@class.name",
            },
        },
    },
})

local spec_treesitter = require("mini.ai").gen_spec.treesitter
local spec_pair = require("mini.ai").gen_spec.pair
vim.b.miniai_config = {
    custom_textobjects = {
        ['"'] = spec_treesitter({
            a = "@string.outer",
            i = "@string.inner",
        }),
        ["'"] = spec_treesitter({
            a = "@string.outer",
            i = "@string.inner",
        }),
    },
}
