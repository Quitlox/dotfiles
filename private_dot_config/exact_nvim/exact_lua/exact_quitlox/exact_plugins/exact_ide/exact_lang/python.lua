return {
    ---------- Editing ----------
    { "chrisgrieser/nvim-puppeteer",     dependencies = { "nvim-treesitter/nvim-treesitter" }, lazy = false },
    ---------- Indent ----------
    -- Fix indentation after assignment / brackets
    -- https://www.reddit.com/r/neovim/comments/y9qkks/problem_with_python_identation_when_using/
    -- https://www.reddit.com/r/neovim/comments/13d3hy5/different_autopair_indentation_on_cr_in_python/
    { "Vimjas/vim-python-pep8-indent" },
    ---------- Text Objects ----------
    -- Indent Text Object (for Python)
    { "michaeljsmith/vim-indent-object", ft = "python" },
    ---------- Virtual Environment ----------
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        opts = {},
        keys = {
            { "<leader>mv", "<cmd>VenvSelect<cr>",       desc = "Open VenvSelector" },
            { "<leader>mc", "<cmd>VenvSelectCached<cr>", desc = "Retrieve Venv from Cache" },
        },
    },

    --  +----------------------------------------------------------+
    --  |     LSP Config                                           |
    --  +----------------------------------------------------------+
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            handlers = {
                ["pyright"] = function()
                    require("lspconfig").pyright.setup({
                        on_attach = function(client, bufnr)
                            local function filter_diagnostics(diagnostic)
                                if diagnostic.source ~= "Pyright" then return true end
                                -- Just disable 'is not accessed' altogether
                                if string.match(diagnostic.message, '".+" is not accessed') then return false end
                                return true
                            end

                            local function custom_on_publish_diagnostics(a, params, client_id, c, config)
                                require("quitlox.util.lua").filter(params.diagnostics, filter_diagnostics)
                                vim.lsp.diagnostic.on_publish_diagnostics(a, params, client_id, c, config)
                            end

                            client.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                            custom_on_publish_diagnostics, {})
                        end,
                        capabilities = require("quitlox.util").make_capabilities(),
                    })
                end,
                ["pylsp"] = function()
                    require("lspconfig").pylsp.setup({
                        capabilities = require("quitlox.util").make_capabilities(),
                        settings = {
                            pylsp = {
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
        -- FIXME: This is too late apparently
        -- ft = "python",
        lazy = false,
        config = function()
            local path = require("quitlox.util.path")
            local pythondap = require("dap-python")

            local debugpy_path = path.concat({ vim.fn.stdpath("data"), "mason", "packages", "debugpy", "venv", "bin",
                "python" })

            if path.exists(debugpy_path) then
                -- Setup Python DAP and point to debugpy
                pythondap.setup(debugpy_path)
                -- Set pytest as default test runner
                pythondap.rest_runner = "pytest"

                -- Set keymaps specifically for python
                require("which-key").register({
                    -- x = { pythondap.test_class, "Debug Class" },
                    y = { pythondap.test_method, "Debug Method" },
                }, { prefix = "<leader>d" })
                require("which-key").register({
                    s = { pythondap.debug_selection, "Debug Selection" },
                }, { prefix = "<leader>d", mode = "v" })
            else
                vim.notify('For Python debugging, install debugpy using: ":MasonInstall debugpy"', "WARN",
                    { title = "No Python Debugging", timeout = 3000 })
            end
        end,
    },
}
