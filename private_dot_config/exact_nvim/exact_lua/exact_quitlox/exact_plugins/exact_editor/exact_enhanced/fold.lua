return {
    -- Pretty Folds
    {
        "kevinhwang91/nvim-ufo",
        dependencies = {
            { "anuvyklack/pretty-fold.nvim", opts = { fill_char = "-" }, config = true, version = "" },
            { "kevinhwang91/promise-async",  version = "" },
        },
        name = "ufo",
        opts = {
            provider_selector = function(bufnr, filetype, buftype) return { "treesitter", "indent" } end,
        },
        keys = {
            { "zR", function() require("ufo").openAllFolds() end,         desc = "Open all folds" },
            { "zM", function() require("ufo").closeAllFolds() end,        desc = "Close all folds" },
            { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Fold less" },
            { "zm", function() require("ufo").closeFoldsWith() end,       desc = "Fold more" },
        },
        init = function()
            vim.o.foldcolumn = "0"
            vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
            -- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
        end,
    },
    {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = function(_, opts)
            opts.commands = opts.commands or {}
            table.insert(opts.commands, {
                ":UfoEnable",
                description = "Enable ufo",
            })
            table.insert(opts.commands, {
                ":UfoDisable",
                description = "Disable ufo",
            })
            table.insert(opts.commands, {
                ":UfoInspect",
                description = "Inspect current buffer information",
            })
            table.insert(opts.commands, {
                ":UfoAttach",
                description = "Attach current buffer to enable all features",
            })
            table.insert(opts.commands, {
                ":UfoDetach",
                description = "Detach current buffer to disable all features",
            })
            table.insert(opts.commands, {
                ":UfoEnableFold",
                description = "Enable to get folds and update them at once for current buffer",
            })
            table.insert(opts.commands, {
                ":UfoDisableFold",
                description = "Disable to get folds for current buffer",
            })
        end,
    },
}
