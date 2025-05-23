--+- LSP: JSON / YAML----------------------------------------+
require("quitlox.util.lazy").on_module("lspconfig", function()
    require("lspconfig").jsonls.setup({
        settings = {
            json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
            },
        },
    })

    -- TODO: try yaml-companion again
    require("lspconfig").yamlls.setup({
        settings = {
            yaml = {
                schemaStore = {
                    -- You must disable built-in schemaStore support if you want to use
                    -- this plugin and its advanced options like `ignore`.
                    enable = false,
                    -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                    url = "",
                },
                schemas = require("schemastore").yaml.schemas(),
            },
        },
    })
end)
