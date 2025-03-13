-- +---------------------------------------------------------+
-- | OXY2DEV/markview.nvim: Markdown Render in Neovim        |
-- +---------------------------------------------------------+

local presets = require("markview.presets")

require("markview").setup({
    preview = {
        icon_provider = "mini",
    },
    markdown = {},
    latex = {},
})

-- Load the checkboxes module.
require("markview.extras.checkboxes").setup()
vim.keymap.set("n", "X", ":Checkbox toggle<cr>", { desc = "Toggle Checkbox" })
