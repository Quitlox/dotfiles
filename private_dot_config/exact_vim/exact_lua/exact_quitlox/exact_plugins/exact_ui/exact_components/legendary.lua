return {
    "mrjones2014/legendary.nvim",
    version = "",
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
            k = { "<cmd>Legendary<cr>", "Vim Keymap" },
        }, { prefix = "<leader>v" })
    end,
    extensions = {
        nvim_tree=true,
        diffview=true,
    }
}
