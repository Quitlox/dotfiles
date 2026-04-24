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
-- Tree-sitter Move (buffer-local, only for filetypes with a treesitter parser)
local ts_move = require('nvim-treesitter-textobjects.move')
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreesitterTextobjectsMove", { clear = true }),
    callback = function(args)
        local ok, parser = pcall(vim.treesitter.get_parser, args.buf)
        if not ok or not parser then return end

        local function map(modes, lhs, fn, desc)
            vim.keymap.set(modes, lhs, fn, { buffer = args.buf, desc = desc })
        end

        map({"n","x","o"}, "]m", function() ts_move.goto_next_start("@function.outer", "textobjects") end, "Next Function Start")
        map({"n","x","o"}, "[m", function() ts_move.goto_previous_start("@function.outer", "textobjects") end, "Previous Function Start")
        map({"n","x","o"}, "]M", function() ts_move.goto_next_end("@function.outer", "textobjects") end, "Next Function End")
        map({"n","x","o"}, "[M", function() ts_move.goto_previous_end("@function.outer", "textobjects") end, "Previous Function End")

        map({"n","x","o"}, "]]", function() ts_move.goto_next_start("@class.outer", "textobjects") end, "Next Class Start")
        map({"n","x","o"}, "[[", function() ts_move.goto_previous_start("@class.outer", "textobjects") end, "Previous Class Start")

        map({"n","x","o"}, "]a", function() ts_move.goto_next_start("@parameter.inner", "textobjects") end, "Next Parameter Start")
        map({"n","x","o"}, "[a", function() ts_move.goto_previous_start("@parameter.inner", "textobjects") end, "Previous Parameter Start")
        map({"n","x","o"}, "]A", function() ts_move.goto_next_end("@parameter.outer", "textobjects") end, "Next Parameter End")
        map({"n","x","o"}, "[A", function() ts_move.goto_previous_end("@parameter.outer", "textobjects") end, "Previous Parameter End")

        map({"n","x","o"}, "]L", function() ts_move.goto_next_end("@loop.outer", "textobjects") end, "Next Loop End")
        map({"n","x","o"}, "[L", function() ts_move.goto_previous_end("@loop.outer", "textobjects") end, "Previous Loop End")
    end,
})

-- Tree-sitter Swap
local ts_swap = require('nvim-treesitter-textobjects.swap')
vim.keymap.set("n", ">a", function() ts_swap.swap_next("@parameter.inner") end, { desc = "Swap Next Parameter" })
vim.keymap.set("n", "<a", function() ts_swap.swap_previous("@parameter.inner") end, { desc = "Swap Previous Parameter" })
-- stylua: ignore end

-- NOTE: Filetype specific textobjects currently configured in:
-- - ftplugin/python.lua
