return {
    "mrjones2014/smart-splits.nvim",
    version = "",
    config = function()
        require("legendary").setup({
            extensions = {
                -- default settings shown below:
                smart_splits = {
                    directions = { "h", "j", "k", "l" },
                    mods = {
                        -- for moving cursor between windows
                        move = "<C>",
                        -- for resizing windows
                        resize = "<M>",
                        -- for swapping window buffers
                        swap = false, -- false disables creating a binding
                    },
                },
            },
        })
    end,
}
