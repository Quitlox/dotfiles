return {
    "folke/which-key.nvim",
    version = "",
    dependencies = { "mrjones2014/legendary.nvim" },
    lazy = false,
    opts = {
        operators = { gc = "Comments" },
        default = {},
        spec = {
            { "<leader><tab>", group = "Tab" },
            { "<leader>b", group = "Buffer" },
            { "<leader>f", group = "Find" },
            { "<leader>v", group = "Vim" },
            { "<leader>T", group = "Toggle" },
            { "<leader>l", group = "Locate" },
            { "<leader>o", group = "Open" },
            { "<leader>w", group = "Window" },
            { "<leader>m", group = "Miscelleneous" },

            { "<leader>g", group = "Git" },

            { "<leader><cr>", hidden = true },
            { "<leader><leader>", hidden = true },
            { "gk", hidden = true },
            { "gj", hidden = true },
        },
        plugins = {
            marks = true,
            registers = true,
            presets = {
                operators = false,
                motions = false,
                text_objects = false,
                windows = false,
                nav = false,
                z = true,
                g = false,
            },
            spelling = {
                enabled = true,
            },
        },
        ignore_missing = false,
        -- icons = { group = "", separator = " " },
        -- layout = {
        --     align = "center",
        -- },
        -- window = {
        --     border = "single",
        --     winblend = 0,
        -- },
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        wk.add(opts.default)
    end,
}
