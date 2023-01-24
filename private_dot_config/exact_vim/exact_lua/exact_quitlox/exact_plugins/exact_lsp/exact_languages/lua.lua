----------------------------------------------------------------------
--                    Lua Language Configuration                    --
----------------------------------------------------------------------

----------------------------------------
-- Neodev
----------------------------------------
-- Developer support for Neovim configuration and Neovim plugin development
-- Needs to be loaded before lspconfig

local neodev_ok, neodev = pcall(require, "neodev")
if not neodev_ok then return end
neodev.setup({})

----------------------------------------
-- LSP Config
----------------------------------------
local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then return end

local capabilities = require("quitlox.plugins.lsp.include.common").capabilities
local on_attach = require("quitlox.plugins.lsp.include.common").on_attach

lspconfig.sumneko_lua.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                checkThirdParty = false,
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})
