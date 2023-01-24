----------------------------------------------------------------------
--                   YAML Language Configuration                    --
----------------------------------------------------------------------

-- Require LspConfig
local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then return end
-- Require YAML Companion
local yaml_companion_ok, yaml_companion = pcall(require, "yaml-companion")
if not yaml_companion_ok then return end

-- Configuration
local capabilities = require("quitlox.plugins.lsp.include.common").capabilities

local on_attach = require("quitlox.plugins.lsp.include.common").on_attach

-- TODO: Add keybinding for :Telescope yaml_schema
-- TODO: For fancyness, I should check whether a schema is found upon opening
-- a yaml file. If not, a popup should appear to hint the user to open
-- :Telescope yaml_schema to select a schema.
local cfg = yaml_companion.setup({
    lspconfig = {
        capabilities = capabilities,
        on_attach = on_attach,
    },
})

lspconfig.yamlls.setup(cfg)
