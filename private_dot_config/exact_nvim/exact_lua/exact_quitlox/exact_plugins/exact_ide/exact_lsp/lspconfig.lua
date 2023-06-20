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
        ["[e"] = {
            "<cmd>lua require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.ERROR })<cr>",
            "Prev Error",
        },
        ["]e"] = {
            "<cmd>lua require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR })<cr>",
            "Prev Error",
        },
        -- Add Go mappings for LSP Symbol navigation
        g = {
            name = "Go",
            D = { "<cmd>Lspsaga peek_definition<cr>", "Peek Declaration" },
            d = { "<cmd>Lspsaga goto_definition<cr>", "Go Definition" },
            i = { function() vim.lsp.buf.implementation() end, "Go Implementation" },
            s = { "<cmd>Telescope lsp_dynamic_workspace_symbols ignore_symbols='variable'<cr>", "Symbols" },
            t = { "<cmd>Lspsaga peek_type_definition<cr>", "Peek Type Definition" },
            R = { "<cmd>Lspsaga rename ++project<cr>", "Go Rename" },
            r = { "<cmd>Lspsaga lsp_finder<cr>", "Go References" },
            h = { "<cmd>Lspsaga hover_doc<cr>", "Hover" },
            f = { function() vim.lsp.buf.format({ bufnr = bufnr }) end, "Format" },
            a = { "<cmd>Lspsaga code_action<cr>", "Action" },
        },
        K = { "<cmd>Lspsaga hover_doc<cr>", "Hover" },
    }, bufopts)

    -- Range formatting
    vim.keymap.set("v", "gf", vim.lsp.buf.format, bufopts)
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
    -- Cursor Highlight
    require("illuminate").on_attach(client)
    -- Default Mappings
    set_keybindings(bufnr)

    -- Disable default inline diagnostics
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Disable virtual_text
        virtual_text = false,
    })

    -- Breadcrumbs
    if client.server_capabilities.documentSymbolProvider then require("nvim-navic").attach(client, bufnr) end
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
            "folke/neodev.nvim",
            "folke/neoconf.nvim",
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",

        -- navic used in quitlox.plugins.lsp.include.common
        dependencies = { "SmiteshP/nvim-navic" },

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
        config = function()
            require("lsp_signature").setup({
                bind = true,
                handler_opts = {
                    border = "single",
                },
                hint_prefix = " ",
                wrap = false,
            })
        end,
    },
}
