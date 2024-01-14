----------------------------------------------------------------------
--                           Indent Line                            --
----------------------------------------------------------------------
-- Display indent lines in the current buffer to visualize the indent depths.
-- The configuration is found in the settings/plugins/shared/indent_line.vim

-- return {
--     "lukas-reineke/indent-blankline.nvim",
--     version = "",
-- }

return {
    {
        "echasnovski/mini.indentscope",
        version = "",
        config = function(_, opts)
            -- Disable indent scope for NvimTree and terminal buffers
            vim.cmd([[
                    augroup DisableIndentScope 
                        autocmd!
                        autocmd Filetype NvimTree lua vim.b.miniindentscope_disable = true 
                        autocmd Filetype lazy lua vim.b.miniindentscope_disable = true 
                        autocmd Filetype mason lua vim.b.miniindentscope_disable = true 
                        autocmd TermOpen * lua vim.b.miniindentscope_disable = true
                    augroup END
            ]])

            require("mini.indentscope").setup(opts)
        end,
        opts = {},
    },
}
