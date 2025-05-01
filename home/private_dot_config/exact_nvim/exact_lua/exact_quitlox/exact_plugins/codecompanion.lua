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
            adapter = "anthropic",
            keymaps = {
                completion = { modes = { i = "<leader>cx" } },
                change_adapter = { modes = { n = "gA" } },
                previous_chat = { modes = { n = "[c" } },
                next_chat = { modes = { n = "]c" } },
            },
            slash_commands = {
                --+- Integration: snacks.nvim
                ["file"] = {
                    opts = {
                        provider = "snacks",
                    },
                },
            },
        },
        inline = {
            adapter = "anthropic",
            keymaps = {
                accept_change = { modes = { n = "<leader>ca" } },
                reject_change = { modes = { n = "<leader>cr" } },
            },
        },
    },

    extensions = {
        --+- Integration: VectorCode
        vectorcode = {
            opts = { add_tool = true, add_slash_command = true, tool_opts = {} },
        },
        --+- Integration: MCPHub
        mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
                show_result_in_chat = true, -- Show the mcp tool result in the chat buffer
                make_vars = true, -- make chat #variables from MCP server resources
                make_slash_commands = true, -- make /slash_commands from MCP server prompts
            },
        },
    },
})

--+- Integration: fidget.nvim -------------------------------+
require("integrations.codecompanion-fidget"):init()

--+- Keymaps ------------------------------------------------+
-- vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>c", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true, desc = "Toggle Chat" })
vim.keymap.set("v", "<leader>c", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

--+- Commands -----------------------------------------------+
-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
