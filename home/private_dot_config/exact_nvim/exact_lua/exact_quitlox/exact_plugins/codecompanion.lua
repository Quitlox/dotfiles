-- +---------------------------------------------------------+
-- | olimorris/codecompanion.nvim                            |
-- +---------------------------------------------------------+

require("codecompanion").setup({
    strategies = {
        chat = {
            adapter = "anthropic",
            slash_commands = {
                ["file"] = {
                    opts = {
                        provider = "telescope",
                    },
                },
            },
        },
        inline = {
            adapter = "anthropic",
        },
    },
})

--+- Integration: fidget.nvim -------------------------------+
require("plugins.codecompanion.fidget-spinner"):init()

--+- Keymaps ------------------------------------------------+
-- vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>c", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

--+- Commands -----------------------------------------------+
-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
