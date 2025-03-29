-- +---------------------------------------------------------+
-- | olimorris/codecompanion.nvim                            |
-- +---------------------------------------------------------+

require("codecompanion").setup({
    strategies = {
        chat = {
            adapter = "anthropic",
            keymaps = {
                completion = { modes = { i = "<C-space>" } }, -- FIXME: doesn't work
            },
            slash_commands = {
                --+- Integration: snacks.nvim
                ["file"] = {
                    opts = {
                        provider = "snacks",
                    },
                },
                --+- Integration: VectorCode
                codebase = require("vectorcode.integrations").codecompanion.chat.make_slash_command(),
            },
            tools = {
                vectorcode = {
                    description = "Run VectorCode to retrieve the project context.",
                    callback = require("vectorcode.integrations").codecompanion.chat.make_tool(),
                },
            },
        },
        inline = {
            adapter = "anthropic",
        },
    },
})

--+- Integration: fidget.nvim -------------------------------+
require("integrations.codecompanion-fidget"):init()

--+- Keymaps ------------------------------------------------+
-- vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>c", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true, desc = "Toggle Chat" })
-- vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

--+- Commands -----------------------------------------------+
-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
