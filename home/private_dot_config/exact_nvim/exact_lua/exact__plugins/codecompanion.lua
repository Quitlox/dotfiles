-- +---------------------------------------------------------+
-- | olimorris/codecompanion.nvim                            |
-- +---------------------------------------------------------+

require("codecompanion").setup({
    adapters = {
        http = {
            acp = {
                claude_code = function()
                    return require("codecompanion.adapters").extend("claude_code", {
                        env = "ANTHROPIC_API_KEY",
                    })
                end,
            },
        },
    },
    interactions = {
        chat = {
            adapter = "copilot",
            model = "claude-sonnet-4.5",
            keymaps = {
                completion = { modes = { i = "<c-space>" } },
                change_adapter = { modes = { n = "gA" } },
                previous_chat = { modes = { n = "[c" } },
                next_chat = { modes = { n = "]c" } },
                new_chat = {
                    modes = { n = "gn" },
                    callback = function()
                        require("codecompanion").chat()
                    end,
                    description = "Open a new chat",
                },
            },
            slash_commands = {
                --+- Integration: snacks.nvim
                ["file"] = { opts = { provider = "snacks" } },
                ["help"] = { opts = { provider = "snacks" } },
                ["buffer"] = { opts = { provider = "snacks" } },
                ["fetch"] = { opts = { provider = "snacks" } },
                ["image"] = { opts = { provider = "snacks" } },
            },
        },
        inline = {
            adapter = "copilot",
            model = "GPT-5.1-Codex-Mini",
            keymaps = {
                -- accept_change = { modes = { n = "<leader>ca" } },
                -- reject_change = { modes = { n = "<leader>cr" } },
            },
        },
    },

    extensions = vim.tbl_extend("force", {
        --+- Integration: MCPHub
        -- FIXME: Not yet updated for v18.0.0
        -- mcphub = {
        --     callback = "mcphub.extensions.codecompanion",
        --     opts = {
        --         show_result_in_chat = true,
        --         make_vars = true,
        --         make_slash_commands = true,
        --     },
        -- },
        --+- Integration: codecompanion-history
        history = {
            enabled = true,
            opts = {
                picker = "snacks",
                title_generation_opts = { adapter = "openai", model = "gpt-5" },
            },
        },
        --+- Integration: codecompanion-spinner
        spinner = { opts = { style = "lualine" } },
    }, vim.fn.executable("vectorcode") == 1 and {
        -- FIXME: Not yet updated for v18.0.0
        --+- Integration: VectorCode
        -- vectorcode = {
        --     opts = {},
        -- },
    } or {}),

    prompt_library = {
        markdown = {
            dirs = { "~/.config/nvim/cc_prompts" },
        },
    },
})

--+- Keymaps ------------------------------------------------+
-- vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>c", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true, desc = "Toggle Chat" })
vim.keymap.set("v", "<leader>c", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>C", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

--+- Commands -----------------------------------------------+
-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])
