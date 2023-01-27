----------------------------------------------------------------------
--                           Keybindings                            --
----------------------------------------------------------------------

return {
    "folke/which-key.nvim",
    priority = 800, -- Should be after Legendary
    config = function(_, opts)
        require("which-key").setup(opts)

        require("quitlox.plugins.keybindings.include.window")
        require("quitlox.plugins.keybindings.include.vim")
        require("quitlox.plugins.keybindings.include.tab")
        require("quitlox.plugins.keybindings.include.misc")
    end,
    opts = {
        operators = { gc = "Comments" },
        plugins = {
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
