--  +----------------------------------------------------------+
--  | LSP Keybindings                                          |
--  +----------------------------------------------------------+
local function set_keybindings(bufnr)
    local bufopts = { silent = true, noremap = true, buffer = bufnr }
    local wk = require("which-key")

    wk.register({
        ["<F2>"] = { vim.lsp.buf.rename, "Rename Symbol" },
        -- stylua: ignore start
        ["[d"] = { function() vim.diagnostic.goto_prev({severity= { min = vim.diagnostic.severity.INFO } }) end, "Prev Diagnostic" },
        ["]d"] = { function() vim.diagnostic.goto_next({severity= { min = vim.diagnostic.severity.INFO } }) end, "Next Diagnostic" },
        ["[w"] = { function() vim.diagnostic.goto_prev({severity= { min = vim.diagnostic.severity.WARN } }) end, "Prev Diagnostic" },
        ["]w"] = { function() vim.diagnostic.goto_next({severity= { min = vim.diagnostic.severity.WARN } }) end, "Next Diagnostic" },
        ["[e"] = { function() vim.diagnostic.goto_prev({ severity=vim.diagnostic.severity.ERROR }) end, "Prev Error" },
        ["]e"] = { function() vim.diagnostic.goto_next({ severity=vim.diagnostic.severity.ERROR }) end, "Prev Error" },
        -- stylua: ignore end
        -- Add Go mappings for LSP Symbol navigation
        g = {
            name = "Go",
            s = { "<cmd>Telescope lsp_dynamic_workspace_symbols ignore_symbols='variable'<cr>", "Symbols" },
        },
    }, bufopts)

    -- Insert mode keybindings
    bufopts.mode = "i"
    wk.register({ ["<C-p>"] = { vim.lsp.buf.signature_help, "Signature Help" } }, bufopts)
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
    require("quitlox.util").legendary({
        { ":LspInfo", "Show the status of active and configured language servers." },
        { ":LspStart", "Start the requested server name." },
        { ":LspStop", "Stop the requested server name." },
        { ":LspRestart", "Restart the requested server name." },
    }),
    -- Workspace Diagnostics Helper
    {
        "artemave/workspace-diagnostics.nvim",
        config = function()
            require("quitlox.util").on_attach(function(client, bufnr)
                whitelist = { "tsserver", "pyright" }
                if vim.tbl_contains(whitelist, client.name) then
                    require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
                end
            end)
        end,
    },
    -- DocumentLink Handler
    {
        "icholy/lsplinks.nvim",
        opts = {},
        keys = {
            { "gx", "<cmd>lua require('lsplinks').gx()<cr>", desc = "Go to document link" },
        },
    },
}
