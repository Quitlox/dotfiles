return {
    ---------- Editing ----------
    { "chrisgrieser/nvim-puppeteer",     dependencies = { "nvim-treesitter/nvim-treesitter" }, lazy = false },
    ---------- Indent ----------
    -- Fix indentation after assignment / brackets
    -- https://www.reddit.com/r/neovim/comments/y9qkks/problem_with_python_identation_when_using/
    -- https://www.reddit.com/r/neovim/comments/13d3hy5/different_autopair_indentation_on_cr_in_python/
    -- NOTE: Disabled as experiment. Is this needed?
    -- { "Vimjas/vim-python-pep8-indent" },
    ---------- Text Objects ----------
    -- Indent Text Object (for Python)
    { "michaeljsmith/vim-indent-object", ft = "python" },
    ---------- Virtual Environment ----------
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        opts = {
            name = {
                "venv",
                "venv3.8",
                "venv3.9",
                "venv3.10",
                "venv3.11",
                "venv3.12",
                ".venv",
                ".venv3.8",
                ".venv3.9",
                ".venv3.10",
                ".venv3.11",
                ".venv3.12",
            },
            dap_enabled = true,
        },
        keys = {
            { "<localleader>vs", "<cmd>VenvSelect<cr>",       desc = "Select Virtual Env" },
            { "<localleader>vc", "<cmd>VenvSelectCached<cr>", desc = "Retrieve Virtual Env from Cache" },
        },
        -- init = function()
        --     vim.api.nvim_create_autocmd("VimEnter", {
        --         desc = "Auto select virtualenv Nvim open",
        --         pattern = "*",
        --         callback = function()
        --             local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
        --             if venv ~= "" then
        --                 require("venv-selector").retrieve_from_cache()
        --             end
        --         end,
        --         once = true,
        --     })
        -- end,
    },
    {
        "folke/which-key.nvim",
        optional = true,
        opts = {
            defaults = {
                ["<localleader>v"] = { name = "Virtual Env" },
            }
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

                            client.handlers["textDocument/publishDiagnostics"] =
                                vim.lsp.with(custom_on_publish_diagnostics, {})
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
        -- FIXME: This is too late apparently
        -- ft = "python",
        lazy = false,
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
                require("which-key").register({
                    -- x = { pythondap.test_class, "Debug Class" },
                    y = { pythondap.test_method, "Debug Method" },
                }, { prefix = "<leader>d" })
                require("which-key").register({
                    s = { pythondap.debug_selection, "Debug Selection" },
                }, { prefix = "<leader>d", mode = "v" })
            else
                vim.notify(
                    'For Python debugging, install debugpy using: ":MasonInstall debugpy"',
                    "WARN",
                    { title = "No Python Debugging", timeout = 3000 }
                )
            end
        end,
    },

    --  +----------------------------------------------------------+
    --  |     REPL                                                 |
    --  +----------------------------------------------------------+

    {
        "Vigemus/iron.nvim",
        lazy = false,
        config = function()
            require("iron.core").setup({
                config = {
                    -- Whether a repl should be discarded or not
                    scratch_repl = true,
                    -- Your repl definitions come here
                    repl_definition = {
                        sh = {
                            -- Can be a table or a function that
                            -- returns a table (see below)
                            command = { "zsh" },
                        },
                    },
                    -- How the repl window will be displayed
                    -- See below for more information
                    repl_open_cmd = require("iron.view").bottom(40),
                },
                -- Iron doesn't set keymaps by default anymore.
                -- You can set them here or manually add keymaps to the functions in iron.core
                keymaps = {
                    send_motion = "<space>rc",
                    visual_send = "<space>rc",
                    send_file = "<space>rf",
                    send_line = "<space>rl",
                    send_until_cursor = "<space>ru",
                    send_mark = "<space>rm",
                    mark_motion = "<space>rmc",
                    mark_visual = "<space>rmc",
                    remove_mark = "<space>rmd",
                    cr = "<space>r<cr>",
                    interrupt = "<space>rx",
                    exit = "<space>rq",
                    clear = "<space>rl",
                },
                -- If the highlight is on, you can change how it looks
                -- For the available options, check nvim_set_hl
                highlight = {
                    italic = true,
                },
                ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
            })
        end,
    },
    {
        "folke/which-key.nvim",
        opts = {
            defaults = {
                ["<leader>r"] = { name = "REPL" },
            },
        },
    },
    {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = function(_, opts)
            opts.commands = opts.commands or {}
            vim.list_extend(opts.commands, {
                { "IronRepl",     description = "Open a repl for current or given file type" },
                { "IronReplHere", description = "Open a repl for current or given file type in the current window" },
                { "IronRestart",  description = "Restart the current repl" },
                { "IronSend",     description = "Sends the supplied chunk of text to the repl for current filtetype" },
                { "IronFocus",    description = "Focuses on the repl for current or given file type" },
                { "IronHide",     description = "Hide the repl window for current or given file type" },
                { "IronWatch",    description = "Send the file/mark to the repl after writing the buffer" },
                { "IronAttach",   description = "Attach current buffer regardless of its filtetype to a repl" },
            })
        end,
    },
}
