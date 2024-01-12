--  +----------------------------------------------------------+
--  | LSP Keybindings                                          |
--  +----------------------------------------------------------+

local function set_keybindings(bufnr)
    -- Default buffer options
    local bufopts = { silent = true, noremap = true, buffer = bufnr }
    -- Require which-key
    local wk = require("which-key")

    wk.register({
        -- Add [e and ]e for navigating to Error Diagnostics
        -- Add [d and ]d for navigating to any Diagnostics
        ["[d"] = { "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Prev Diagnostic" },
        ["]d"] = { "<cmd>Lspsaga diagnostic_jump_next<cr>", "Prev Diagnostic" },
        ["[e"] = { "<cmd>lua require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.ERROR })<cr>", "Prev Error" },
        ["]e"] = { "<cmd>lua require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR })<cr>", "Prev Error" },
        -- Add Go mappings for LSP Symbol navigation
        g = {
            name = "Go",
            -- O = { "<cmd>Lspsaga outgoing_calls<cr>", "Go Outgoing Calls" },
            -- I = { "<cmd>Lspsaga incoming_calls<cr>", "Go Incoming Calls" },
            s = { "<cmd>Telescope lsp_dynamic_workspace_symbols ignore_symbols='variable'<cr>", "Symbols" },
            R = { "<cmd>Lspsaga rename ++project<cr>", "Go Rename" },
        },
    }, bufopts)

    -- Range formatting
    -- vim.keymap.set("v", "gf", require("conform").format, bufopts) // Set in formatting.lua
    -- Rename
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, bufopts)
    -- Signature Help
    vim.keymap.set("i", "<C-p>", vim.lsp.buf.signature_help)
end

--  +----------------------------------------------------------+
--  | General Server Settings                                  |
--  +----------------------------------------------------------+

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Default Mappings
    set_keybindings(bufnr)

    -- Disable default inline diagnostics
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Disable virtual_text
        virtual_text = false,
    })
end

require("quitlox.util").on_attach(on_attach)

----------------------------------------------------------------------
--                              Mason                               --
----------------------------------------------------------------------
-- Mason is a tool for easily installing third-party language-servers,
-- formatters, linters, debuggers and other utilities for Neovim.
-- Mason also takes care of automatically registering language-servers to LSP
-- and tools to NullLs.

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- These need to be ran before nvim-lspconfig
            { "folke/neodev.nvim", opts = {} },
            "folke/neoconf.nvim",
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        version = "",

        opts = {
            automatic_installation = false,
            ensure_installed = { "jsonls" }, -- For Neoconf configuration file completion to work out of the box
        },

        config = function(_, opts)
            local lspconfig = require("lspconfig")

            local mason_lspconfig = require("mason-lspconfig")
            mason_lspconfig.setup(opts)

            local capabilities = require("quitlox.util").make_capabilities()

            -- Automatic setup of all LSPs
            mason_lspconfig.setup_handlers({
                function(server_name)
                    lspconfig[server_name].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,
            })
        end,
    },

    -- Function Signature popup
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        -- Causes hiccups (especiialy when using tailwind)
        -- BUG: https://github.com/hrsh7th/nvim-cmp/issues/1613
        config = function()
            require("lsp_signature").setup({
                bind = true,
                handler_opts = {
                    border = "single",
                },
                hint_prefix = " ",
                floating_window = false,
                wrap = false,
            })
        end,
    },
}
