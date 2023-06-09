return {
    "ThePrimeagen/harpoon",
    config = function()
        require("harpoon").setup({
            global_settings = {
                save_on_toggle = true,
                save_on_change = true,
            },
        })

        require("which-key").register({
            h = {
                name = "Harpoon",
                a = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Add" },
                l = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "List" },
                n = { "<cmd>lua require('harpoon.ui').nav_next()<cr>", "Next" },
                p = { "<cmd>lua require('harpoon.ui').nav_prev()<cr>", "Prev" },
            },
        }, { prefix = "<leader>" })
    end,
}
