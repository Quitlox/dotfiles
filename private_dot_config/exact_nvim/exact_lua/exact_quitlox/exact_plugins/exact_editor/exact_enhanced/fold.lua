return {
    -- Pretty Folds
    {
        "kevinhwang91/nvim-ufo",
        lazy = false,
        dependencies = {
            { "kevinhwang91/promise-async", version = "" },
        },
        config = function(_, opts) require("ufo").setup(opts) end,
        opts = {
            provider_selector = function(bufnr, filetype, buftype) return { "treesitter", "indent" } end,
        },
        keys = {
            { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
            { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
            { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Fold less" },
            { "zm", function() require("ufo").closeFoldsWith() end, desc = "Fold more" },
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
            local commands = {
                { ":UfoEnable", "Enable ufo" },
                { ":UfoDisable", "Disable ufo" },
                { ":UfoInspect", "Inspect current buffer information" },
                { ":UfoAttach", "Attach current buffer to enable all features" },
                { ":UfoDetach", "Detach current buffer to disable all features" },
                { ":UfoEnableFold", "Enable to get folds and update them at once for current buffer" },
                { ":UfoDisableFold", "Disable to get folds for current buffer" },
            }
            for _, command in ipairs(commands) do
                table.insert(opts.commands, { command[1], description = command[2] })
            end
        end,
    },
}
