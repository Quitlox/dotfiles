return {
    {
        "folke/which-key.nvim",
        optional = true,
        opts = {
            defaults = {
                ["<leader>h"] = { name = "Harpoon" },
            },
        },
    },
    {
        "ThePrimeagen/harpoon",
        opts = {
            global_settings = {
                save_on_toggle = true,
                save_on_change = true,
            },
        },
        keys = {
            { "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<cr>",        desc = "Add" },
            { "<leader>hl", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "List" },
            { "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<cr>",          desc = "Next" },
            { "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<cr>",          desc = "Prev" },
        },
    },
}
