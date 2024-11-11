-- +---------------------------------------------------------+
-- | pmizio/typescript-tools.nvim: Typescript Support        |
-- +---------------------------------------------------------+

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "typescript",
    group = vim.api.nvim_create_augroup("MyTypescriptTools", { clear = true }),
    desc = "Setup Typescript Tools",
    callback = function(args)
        -- Check if 'tsserver' command is available.
        if vim.fn.executable("tsserver") == 0 then
            vim.notify("Typescript server not found. Please install it.", vim.log.levels.ERROR, { title = "Typescript Tools" })
            return
        end

        require("typescript-tools").setup({
            settings = {
                tsserver_file_preferences = function(ft)
                    return {
                        includeInlayParameterNameHints = "all",
                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                    }
                end,
            },
        })
    end,
})

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
