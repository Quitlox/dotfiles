----------------------------------------------------------------------
--                    Lua Language Configuration                    --
----------------------------------------------------------------------

----------------------------------------
-- Neodev
----------------------------------------
-- Developer support for Neovim configuration and Neovim plugin development
-- Needs to be loaded before lspconfig

require("neodev").setup({
    library = { plugins = { "nvim-dap-ui" }, types = true },
})

----------------------------------------
-- LSP Config
----------------------------------------

local lspconfig = require("lspconfig")

-- Configuration
local capabilities = require("quitlox.plugins.ide.lsp.include.common").capabilities
local on_attach = require("quitlox.plugins.ide.lsp.include.common").on_attach

lspconfig.lua_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            completion = {
        callSnippet = "Replace"
      },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})
