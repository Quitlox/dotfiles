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
