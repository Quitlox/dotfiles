return {
    -- Pretty Folds
    {
        "kevinhwang91/nvim-ufo",
        lazy = false,
        dependencies = {
            { "kevinhwang91/promise-async", version = "" },
        },
        config = function(_, opts)
            require("ufo").setup(opts)
            require("hover").register({
                priority = 1002,
                name = "Fold",
                enabled = function(bufnr)
                    local winid = require("ufo").peekFoldedLinesUnderCursor()
                    return winid ~= nil
                end,
                execute = function(opts, done) end,
            })
        end,
        opts = {
            provider_selector = function(bufnr, filetype, buftype)
                return { "treesitter", "indent" }
            end,
        },
        keys = {
            -- stylua: ignore start
            { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds", },
            { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds", },
            { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Fold less" },
            { "zm", function() require("ufo").closeFoldsWith() end, desc = "Fold more" },
            { "[z", function() require("ufo").goPreviousClosedFold() end, desc = "Next fold" },
            { "]z", function() require("ufo").goNextClosedFold() end, desc = "Next fold" },
            -- stylua: ignore end
        },
        init = function()
            vim.o.foldcolumn = "0"
            vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
            -- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
        end,
    },
    require("quitlox.util").legendary({
        { ":UfoEnable", "Enable ufo" },
        { ":UfoDisable", "Disable ufo" },
        { ":UfoInspect", "Inspect current buffer information" },
        { ":UfoAttach", "Attach current buffer to enable all features" },
        { ":UfoDetach", "Detach current buffer to disable all features" },
        { ":UfoEnableFold", "Enable to get folds and update them at once for current buffer" },
        { ":UfoDisableFold", "Disable to get folds for current buffer" },
    }),
}
