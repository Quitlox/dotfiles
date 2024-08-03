return {
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
    },
    require("quitlox.util").legendary({
        { ":TSToolsOrganizeImports", "Sorts and removes unused imports." },
        { ":TSToolsSortImports", "Sorts imports." },
        { ":TSToolsRemoveUnusedImports", "Removes unused imports." },
        { ":TSToolsRemoveUnused", "Removes all unused statements." },
        { ":TSToolsAddMissingImports", "Adds imports for all statements that lack one and can be imported." },
        { ":TSToolsFixAll", "Fixes all fixable errors." },
        { ":TSToolsGoToSourceDefinition", "Goes to source definition." },
        { ":TSToolsRenameFile", "Allow to rename current file and apply changes to connected files." },
        { ":TSToolsFileReferences", "Find files that reference the current file." },
    }),
}
