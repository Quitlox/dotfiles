return {
    ----- Json -----
    -- Autocompletion based on remote SchemaStore
    { "b0o/SchemaStore.nvim", lazy = true },
    ----- YAML -----
    { "someone-stole-my-name/yaml-companion.nvim", lazy = true },
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            handlers = {
                ["yamlls"] = function()
                    -- TODO: For fancyness, I should check whether a schema is found upon opening
                    -- a yaml file. If not, a popup should appear to hint the user to open
                    -- :Telescope yaml_schema to select a schema.

                    local cfg = require("yaml-companion").setup({
                        lspconfig = {
                            capabilities = require("quitlox.util").make_capabilities(),
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
    require("quitlox.util").legendary_full({
        { ":SetYamlSchema", "<cmd>lua require('yaml-companion').open_ui_select()<cr>", description = "Set YAML schema" },
    }),
}
