----------------------------------------------------------------------
--                    Treesitter: comment-string                    --
----------------------------------------------------------------------
-- Helper to automatically set 'commentstring' in files with nested languages
-- TODO: Add all relevant filetypes

return {
    "JoosepAlviste/nvim-ts-context-commentstring",
    ft = "javascript,typescript,tsx,css,scss,php,html,svelte,vue,astro,handlebars,glimmer,graphql,lua",
    config = function()
        require("nvim-treesitter.configs").setup({
            ----- Comment -----
            -- with: JoosepAlviste/nvim-ts-context-commentstring
            context_commentstring = {
                enable = true,
                enable_autocmd = false,
            },
        })
    end,
}