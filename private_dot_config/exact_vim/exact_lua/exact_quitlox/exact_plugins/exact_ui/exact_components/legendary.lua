return {
    "mrjones2014/legendary.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    priority = 900, -- Should be earlier than which-key
    config = function()
        require("legendary").setup({
            which_key = {
                auto_register = true,
                do_binding = false,
            },
        })
        require("which-key").register({
            l = {
                l = { "<cmd>Legendary<cr>", "Vim List Legendary" },
            },
        }, { prefix = "<leader>v" })
    end,
}
