return {
    "folke/which-key.nvim",
    version = "~2.0",
    dependencies = { "mrjones2014/legendary.nvim" },
    keys = { "<leader>" },
    opts = {
        operators = { gc = "Comments" },
        defaults = {
            ["<leader><tab>"] = { name = "Tab" },
            ["<leader>v"] = { name = "Vim" },
            ["<leader>T"] = { name = "Toggle" },
            ["<leader>l"] = { name = "Locate" },
            ["<leader>o"] = { name = "Open" },
            ["<leader>w"] = { name = "Window" },
            ["<leader>m"] = { name = "Miscelleneous" },
            -- Plugins
            ["<leader>g"] = { name = "Git" },
            -- Disable
            ["<leader><cr>"] = "which_key_ignore",
            ["<leader><leader>"] = "which_key_ignore",
            ["gk"] = { name = "which_key_ignore" },
            ["gj"] = { name = "which_key_ignore" },
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
        key_labels = {
            ["<space>"] = "SPC",
            ["<CR>"] = "RET",
            ["<cr>"] = "RET",
            ["<tab>"] = "TAB",
        },
        ignore_missing = false,
        icons = { group = "", separator = " " },
        layout = {
            align = "center",
        },
        window = {
            border = "single",
            winblend = 0,
        },
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        wk.register(opts.defaults)
    end,
}
