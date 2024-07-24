-- +---------------------------------------------------------+
-- | pmizio/typescript-tools.nvim: Typescript Support        |
-- +---------------------------------------------------------+

require("typescript-tools").setup({})

--+- Commands -----------------------------------------------+
require("legendary").commands({
    { ":TSToolsOrganizeImports", description = "Sorts and removes unused imports." },
    { ":TSToolsSortImports", description = "Sorts imports." },
    { ":TSToolsRemoveUnusedImports", description = "Removes unused imports." },
    { ":TSToolsRemoveUnused", description = "Removes all unused statements." },
    { ":TSToolsAddMissingImports", description = "Adds imports for all statements that lack one and can be imported." },
    { ":TSToolsFixAll", description = "Fixes all fixable errors." },
    { ":TSToolsGoToSourceDefinition", description = "Goes to source definition." },
    { ":TSToolsRenameFile", description = "Allow to rename current file and apply changes to connected files." },
    { ":TSToolsFileReferences", description = "Find files that reference the current file." },
})
