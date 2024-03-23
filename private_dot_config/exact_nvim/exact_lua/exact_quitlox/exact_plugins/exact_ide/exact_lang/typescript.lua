return {
    -- FIXME: Replace with new typescript-tools.nvim
    -- https://github.com/pmizio/typescript-tools.nvim
    -- Blocked by: https://github.com/pmizio/typescript-tools.nvim/issues/36

    ----- Typescript -----
    { "jose-elias-alvarez/typescript.nvim", lazy = false },
    {
        "dmmulroy/tsc.nvim",
        cmd = "TSC",
        config = true,
        version = "",
    },
    {
        "williamboman/mason-lspconfig.nvim",
        optional = true,
        opts = {
            handlers = {
                ["tsserver"] = function()
                    local typescript_capabilities = require("quitlox.util").make_capabilities()
                    typescript_capabilities.documentFormattingProvider = false

                    require("typescript").setup({
                        server = {
                            capabilities = typescript_capabilities,
                        },
                    })
                end,
            },
        },
    },

    -- {
    --     "pmizio/typescript-tools.nvim",
    --     dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    --     opts = function() return {} end,
    -- },
    -- require("quitlox.util").legendary({
    --     { ":TSToolsOrganizeImports", "Sorts and removes unused imports." },
    --     { ":TSToolsSortImports", "Sorts imports." },
    --     { ":TSToolsRemoveUnusedImports", "Removes unused imports." },
    --     { ":TSToolsRemoveUnused", "Removes all unused statements." },
    --     { ":TSToolsAddMissingImports", "Adds imports for all statements that lack one and can be imported." },
    --     { ":TSToolsFixAll", "Fixes all fixable errors." },
    --     { ":TSToolsGoToSourceDefinition", "Goes to source definition." },
    --     { ":TSToolsRenameFile", "Allow to rename current file and apply changes to connected files." },
    --     { ":TSToolsFileReferences", "Find files that reference the current file." },
    -- }),
}
