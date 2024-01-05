return {
    ----- Json -----
    -- Autocompletion based on remote SchemaStore
    { "b0o/SchemaStore.nvim",                      lazy = true },
    ----- YAML -----
    { "someone-stole-my-name/yaml-companion.nvim", lazy = true, version = "" },
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            handlers = {
                ["yamlls"] = function()
                    -- TODO: Add keybinding for :Telescope yaml_schema
                    -- TODO: For fancyness, I should check whether a schema is found upon opening
                    -- a yaml file. If not, a popup should appear to hint the user to open
                    -- :Telescope yaml_schema to select a schema.
                    local cfg = require("yaml-companion").setup({
                        lspconfig = {
                            capabilities = capabilities,
                            on_attach = on_attach,
                        },
                    })

                    -- Add as a telescope extension
                    require("telescope").load_extension("yaml_schema")
                    -- Setup LSP
                    require("lspconfig").yamlls.setup(cfg)
                end,
            },
        },
    },
}
