-- +---------------------------------------------------------+
-- | dnlhc/glance.nvim: Code Lens                            |
-- +---------------------------------------------------------+

local before_open_definition = function(results, open, jump, method)
    if #results == 1 then
        jump(results[1])
    else
        open(results)
    end
end

local open_definition = function()
    require("glance").open("definitions", {
        hooks = {
            before_open = before_open_definition,
        },
    })
end

local actions = require("glance").actions
---@diagnostic disable-next-line: missing-fields
require("glance").setup({
    -- hooks = {
    --     before_open = custom_before_open,
    -- },
    mappings = {
        list = {
            ["<leader>l"] = false,
            ["i"] = actions.enter_win("preview"),
            ["<C-t>"] = actions.quickfix,
        },
        preview = {
            ["Q"] = actions.close,
            ["<leader>l"] = false,
            ["q"] = actions.enter_win("list"),
            ["<C-t>"] = actions.quickfix,
        },
    },
    use_trouble_qf = true,
})

vim.keymap.set("n", "gd", open_definition, { desc = "Go Definition" })
vim.keymap.set("n", "gD", "<CMD>Glance definitions<CR>", { desc = "Go Definition" })
vim.keymap.set("n", "gi", "<CMD>Glance implementations<CR>", { desc = "Go Implementation" })
vim.keymap.set("n", "gt", "<CMD>Glance type_definitions<CR>", { desc = "Go Type Definition" })
vim.keymap.set("n", "gr", "<CMD>Glance references<CR>", { desc = "Go References" })
