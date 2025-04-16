-- +---------------------------------------------------------+
-- | olimorris/codecompanion.nvim                            |
-- +---------------------------------------------------------+

require("codecompanion").setup({
    adapters = {
        gemini_pro = function()
            return require("codecompanion.adapters").extend("gemini", {
                name = "gemini_pro",
                schema = {
                    model = {
                        default = "gemini-2.5-pro-exp-03-25",
                    },
                },
            })
        end,
    },
    strategies = {
        chat = {
            adapter = "gemini_pro",
            keymaps = {
                -- completion = { modes = { i = "<C-space>" } }, -- FIXME: doesn't work
                change_adapter = { modes = { n = "gA" } },
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
            adapter = "gemini_pro",
        },
    },
})

--+- Integration: fidget.nvim -------------------------------+
require("integrations.codecompanion-fidget"):init()

--+- Keymaps ------------------------------------------------+
-- vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>c", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true, desc = "Toggle Chat" })
vim.keymap.set("v", "<leader>c", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })

--+- Commands -----------------------------------------------+
-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
