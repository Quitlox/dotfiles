-- +---------------------------------------------------------+
-- | nvim-treesitter/nvim-treesitter-textobjects: Extra      |
-- | Text Objects                                            |
-- +---------------------------------------------------------+

-- Disable entire built-in ftplugin mappings to avoid conflicts.
-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
vim.g.no_plugin_maps = true

-- select is replaced by mini.ai

require("nvim-treesitter-textobjects").setup({
    move = {
        set_jumps = true,
    },
})

-- stylua: ignore start
-- Tree-sitter Move
local ts_move = require('nvim-treesitter-textobjects.move')
vim.keymap.set({"n","x","o",}, "]m", function() ts_move.goto_next_start("@function.outer", "textobjects") end, { desc = "Next Function Start" })
vim.keymap.set({"n","x","o",}, "[m", function() ts_move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Previous Function Start" })
vim.keymap.set({"n","x","o",}, "]M", function() ts_move.goto_next_end("@function.outer", "textobjects") end, { desc = "Next Function End" })
vim.keymap.set({"n","x","o",}, "[M", function() ts_move.goto_previous_end("@function.outer", "textobjects") end, { desc = "Previous Function End" })

vim.keymap.set({"n","x","o",}, "]]", function() ts_move.goto_next_start("@class.outer", "textobjects") end, { desc = "Next Class Start" })
vim.keymap.set({"n","x","o",}, "[[", function() ts_move.goto_previous_start("@class.outer", "textobjects") end, { desc = "Previous Class Start" })

vim.keymap.set({"n","x","o",}, "]a", function() ts_move.goto_next_start("@parameter.inner", "textobjects") end, { desc = "Next Parameter Start" })
vim.keymap.set({"n","x","o",}, "[a", function() ts_move.goto_previous_start("@parameter.inner", "textobjects") end, { desc = "Previous Parameter Start" })
vim.keymap.set({"n","x","o",}, "]A", function() ts_move.goto_next_end("@parameter.outer", "textobjects") end, { desc = "Next Parameter End" })
vim.keymap.set({"n","x","o",}, "[A", function() ts_move.goto_previous_end("@parameter.outer", "textobjects") end, { desc = "Previous Parameter End" })

vim.keymap.set({"n","x","o",}, "]L", function() ts_move.goto_next_end("@loop.outer", "textobjects") end, { desc = "Next Loop End" })
vim.keymap.set({"n","x","o",}, "[L", function() ts_move.goto_previous_end("@loop.outer", "textobjects") end, { desc = "Previous Loop End" })

-- Tree-sitter Swap
local ts_swap = require('nvim-treesitter-textobjects.swap')
vim.keymap.set("n", ">a", function() ts_swap.swap_next("@parameter.inner") end, { desc = "Swap Next Parameter" })
vim.keymap.set("n", "<a", function() ts_swap.swap_previous("@parameter.inner") end, { desc = "Swap Previous Parameter" })
-- stylua: ignore end

-- NOTE: Filetype specific textobjects currently configured in:
-- - ftplugin/python.lua
