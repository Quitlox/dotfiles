-- +---------------------------------------------------------+
-- | folke/trouble.nvim: Quickfix                            |
-- +---------------------------------------------------------+

--+- Setup --------------------------------------------------+
local setup_trouble = function()
    require("trouble").setup({
        auto_preview = false,
        action_keys = {
            close = "q",
            open_split = { "<c-v>" },
            open_vsplit = { "<c-b>" },
            toggle_fold = { "zA", "za", "o" },
        },
        modes = {
            filtered_diagnostics = {
                mode = "diagnostics",
                filter = function(items)
                    return vim.tbl_filter(function(item)
                        if item.item.source == "Pyright" then return false end
                        return true
                    end, items)
                end,
            },
        },
        icons = {
            indent = {
                fold_open = "  ",
                fold_closed = "  ",
                ws = "  ",
            },
            -- codicons
            folder_closed = " ",
            folder_open = " ",
            kinds = {
                Array = " ",
                Boolean = " ",
                Class = " ",
                Constant = " ",
                Constructor = " ",
                Enum = " ",
                EnumMember = " ",
                Event = " ",
                Field = " ",
                File = " ",
                Function = " ",
                Interface = " ",
                Key = " ",
                Method = " ",
                Module = " ",
                Namespace = " ",
                Null = " ",
                Number = " ",
                Object = " ",
                Operator = " ",
                Package = " ",
                Property = " ",
                String = " ",
                Struct = " ",
                TypeParameter = " ",
                Variable = " ",
            },
        },
    })
end

require("quitlox.util.lazy").command_stub_args("Trouble", setup_trouble)

--+- Keymaps ------------------------------------------------+
-- stylua: ignore start
vim.keymap.set("n", "<leader>ow", "<CMD>Trouble filtered_diagnostics<CR>", { desc = "Open Document Diagnostics" })
vim.keymap.set("n", "<leader>od", "<CMD>Trouble filtered_diagnostics<CR>", {desc = "Open All Diagnostics"})
vim.keymap.set("n", "<leader>oq", "<CMD>Trouble quickfix<CR>", { desc = "Open Quickfix" })
-- stylua: ignore end
