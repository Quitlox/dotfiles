----------------------------------------------------------------------
--                   YAML Language Configuration                    --
----------------------------------------------------------------------

-- Require LspConfig
local lspconfig = require('lspconfig')
-- Require YAML Companion
local yaml_companion = require("yaml-companion")

-- Configuration
local capabilities = require("quitlox.plugins.ide.lsp.include.common").capabilities
local on_attach = require("quitlox.plugins.ide.lsp.include.common").on_attach

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

-- Add as a telescope extension
require("telescope").load_extension("yaml_schema")

-- Setup LSP
lspconfig.yamlls.setup(cfg)
