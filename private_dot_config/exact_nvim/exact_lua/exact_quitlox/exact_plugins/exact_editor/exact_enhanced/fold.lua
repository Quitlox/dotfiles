return {
    -- Pretty Folds
    -- { "anuvyklack/pretty-fold.nvim", opts = { fill_char = "-" }, config = true, version = "" },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = {
            { "kevinhwang91/promise-async", version = "" },
        },
        setup = function()
            require("ufo").setup({
                provider_selector = function(bufnr, filetype, buftype) return { "treesitter", "indent" } end,
            })
        end,
        init = function()
            vim.o.foldcolumn = "1" -- '0' is not bad
            vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
            -- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
        end,
    },
}
