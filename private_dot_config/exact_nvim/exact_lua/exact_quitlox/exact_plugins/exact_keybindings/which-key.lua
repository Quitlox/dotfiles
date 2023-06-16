return {
    "folke/which-key.nvim",
    version = "",
    dependencies = {"mrjones2014/legendary.nvim"},
    config = function(_, opts)
        require("which-key").setup(opts)
    end,
    opts = {
        operators = { gc = "Comments" },
        plugins = {
            presets = {
                operators = false,
                motions = false,
                text_objects = true,
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
        ignore_missing = true,
        icons = { group = "", separator = "ﰲ" },
        layout = {
            align = "center",
        },
        window = {
            border = "single",
            winblend = 0,
        },
    },
}
