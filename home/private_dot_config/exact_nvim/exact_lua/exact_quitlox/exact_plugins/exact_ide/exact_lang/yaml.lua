return {
    -- NOTE: Yaml-companion seesm broken. However, the default yaml lsp already
    -- configures the schema store and autodetects the schema, so I don't think
    -- I actually need it.

    ----- Json -----
    -- -- Autocompletion based on remote SchemaStore
    -- { "b0o/SchemaStore.nvim", lazy = true },
    ----- YAML -----
    -- {
    --     "someone-stole-my-name/yaml-companion.nvim",
    --     -- config = function(_, opts) require("telescope").load_extension("yaml_schema") end,
    --     lazy = false,
    --     opts = {
    --         schemas = {
    --             {
    --                 name = "Gitlab CI",
    --                 uri = "https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json",
    --             },
    --         },
    --     },
    -- },
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            handlers = {
                ["yamlls"] = function()
                    -- TODO: For fancyness, I should check whether a schema is found upon opening
                    -- a yaml file. If not, a popup should appear to hint the user to open
                    -- :Telescope yaml_schema to select a schema.

                    -- local cfg = require("yaml-companion").setup({
                    --     lspconfig = {
                    --         capabilities = require("quitlox.util").make_capabilities(),
                    --     },
                    -- })

                    -- Setup LSP
                    require("lspconfig").yamlls.setup({})
                end,
            },
        },
    },
    -- require("quitlox.util").legendary_full({
    --     { ":SetYamlSchema", function() require("yaml-companion").open_ui_select() end, description = "Set YAML schema" },
    -- }),
}
