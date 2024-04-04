--  +----------------------------------------------------------+
--  | LSP Keybindings                                          |
--  +----------------------------------------------------------+

-- Stolen from LazyVim
local diagnostic_goto = function(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function() go({ severity = severity }) end
end

local function set_keybindings(bufnr)
    local bufopts = { silent = true, noremap = true, buffer = bufnr }
    local wk = require("which-key")

    wk.register({
        ["<F2>"] = { vim.lsp.buf.rename, "Rename Symbol" },
        -- Add [e and ]e for navigating to Error Diagnostics
        -- Add [d and ]d for navigating to any Diagnostics
        ["[d"] = { vim.diagnostic.goto_prev, "Prev Diagnostic" },
        ["]d"] = { vim.diagnostic.goto_next, "Next Diagnostic" },
        ["[e"] = { diagnostic_goto(false, "ERROR"), "Prev Error" },
        ["]e"] = { diagnostic_goto(true, "ERROR"), "Prev Error" },
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
            {
                "folke/neodev.nvim",
                opts = {
                    override = function(root_dir, library)
                        -- Enable neodev for plugin directory
                        if root_dir:find("/home/quitlox/.local/share/nvim", 1, true) == 1 then
                            library.enabled = true
                            library.plugins = true
                        end
                    end,
                },
            },
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
                if vim.tbl_contains(whitelist, client.name) then require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr) end
            end)
        end,
    },
    -- DocumentLink Handler
    {
        "icholy/lsplinks.nvim",
        setup = function()
            local lsplinks = require("lsplinks")
            lsplinks.setup()
            vim.keymap.set("n", "gx", lsplinks.gx)
        end,
    },
}
