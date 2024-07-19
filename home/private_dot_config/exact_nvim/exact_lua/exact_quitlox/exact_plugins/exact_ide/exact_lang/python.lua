return {
    ---------- Indent ----------
    -- Fix indentation after assignment / brackets
    -- https://www.reddit.com/r/neovim/comments/y9qkks/problem_with_python_identation_when_using/
    -- https://www.reddit.com/r/neovim/comments/13d3hy5/different_autopair_indentation_on_cr_in_python/
    -- NOTE: Disabled as experiment. Is this needed?
    -- { "Vimjas/vim-python-pep8-indent" },

    ---------- Virtual Environment ----------
    {
        "linux-cultist/venv-selector.nvim",
        branch = "regexp", -- FIXME: At some point, this should be merged into the main branch
        dependencies = { "neovim/nvim-lspconfig" },
        config = true,
        lazy = false,
    },
    require("quitlox.util").legendary_full({
        { ":VenvSelect", description = "Select Virtual Env" },
        { ":VenvDeactivate", ":lua require('venv-selector').deactivate()<cr>", description = "Deactivate Virtual Env" },
    }),
    require("quitlox.util").whichkey({
        { "<localleader>v", group = "Virtual Env" },
    }),

    --  +----------------------------------------------------------+
    --  |     LSP Config                                           |
    --  +----------------------------------------------------------+
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            handlers = {
                ["pyright"] = function()
                    ---@diagnostic disable-next-line: missing-fields
                    require("lspconfig").pyright.setup({
                        on_attach = function(client, bufnr)
                            local function filter_diagnostics(diagnostic)
                                if diagnostic.source ~= "Pyright" then
                                    return true
                                end
                                -- Just disable 'is not accessed' altogether
                                if string.match(diagnostic.message, '".+" is not accessed') then
                                    return false
                                end
                                return true
                            end

                            local function custom_on_publish_diagnostics(a, params, client_id, c, config)
                                require("quitlox.util.lua").filter(params.diagnostics, filter_diagnostics)
                                vim.lsp.diagnostic.on_publish_diagnostics(a, params, client_id, c, config)
                            end

                            client.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(custom_on_publish_diagnostics, {})
                        end,
                        capabilities = require("quitlox.util").make_capabilities(),
                    })
                end,
                ["pylsp"] = function()
                    require("lspconfig").pylsp.setup({
                        capabilities = require("quitlox.util").make_capabilities(),
                        settings = {
                            pylsp = {
                                ---@diagnostic disable-next-line: missing-fields
                                plugins = {
                                    black = { enabled = true },
                                    autopep8 = { enabled = false },
                                },
                            },
                        },
                    })
                end,
            },
        },
    },

    --  +----------------------------------------------------------+
    --  |     Neotest                                              |
    --  +----------------------------------------------------------+

    { "nvim-neotest/neotest-python", lazy = true },
    {
        "nvim-neotest/neotest",
        optional = true,
        dependencies = { "nvim-neotest/neotest-python" },
        opts = {
            adapters = {
                ["neotest-python"] = {
                    dap = { justMyCode = true },
                    args = { "--log-level", "DEBUG", "--log-cli-level", "DEBUG", "-v" },
                },
            },
        },
    },

    --  +----------------------------------------------------------+
    --  |     DAP                                                  |
    --  +----------------------------------------------------------+
    -- This file contains the lazy.nvim plugin spec for the nvim-dap-python
    -- plugin, which is a wrapper around the debugpy Python debugger.

    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        config = function()
            local path = require("quitlox.util.path")
            local pythondap = require("dap-python")

            local debugpy_path = path.concat({
                vim.fn.stdpath("data"),
                "mason",
                "packages",
                "debugpy",
                "venv",
                "bin",
                "python",
            })

            if path.exists(debugpy_path) then
                -- Setup Python DAP and point to debugpy
                pythondap.setup(debugpy_path)
                -- Set pytest as default test runner
                pythondap.rest_runner = "pytest"

                -- Set keymaps specifically for python
                require("which-key").add({
                    -- x = { pythondap.test_class, "Debug Class" },
                    { "<leader>dy", pythondap.test_method, desc = "Debug Method" },
                })
                require("which-key").add({
                    { "<leader>ds", pythondap.debug_selection, desc = "Debug Selection", mode = "v" },
                })
            else
                vim.notify('For Python debugging, install debugpy using: ":MasonInstall debugpy"', "WARN", { title = "No Python Debugging", timeout = 3000 })
            end
        end,
    },

    --  +----------------------------------------------------------+
    --  |     REPL                                                 |
    --  +----------------------------------------------------------+

    {
        "folke/which-key.nvim",
        opts = {
            default = {
                { "<leader>r", group = "REPL" },
            },
        },
    },
    {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = function(_, opts)
            opts.commands = opts.commands or {}
            vim.list_extend(opts.commands, {
                { "IronRepl", description = "Open a repl for current or given file type" },
                { "IronReplHere", description = "Open a repl for current or given file type in the current window" },
                { "IronRestart", description = "Restart the current repl" },
                { "IronSend", description = "Sends the supplied chunk of text to the repl for current filtetype" },
                { "IronFocus", description = "Focuses on the repl for current or given file type" },
                { "IronHide", description = "Hide the repl window for current or given file type" },
                { "IronWatch", description = "Send the file/mark to the repl after writing the buffer" },
                { "IronAttach", description = "Attach current buffer regardless of its filtetype to a repl" },
            })
        end,
    },
}
