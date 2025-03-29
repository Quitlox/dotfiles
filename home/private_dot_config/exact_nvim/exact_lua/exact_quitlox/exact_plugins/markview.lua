-- +---------------------------------------------------------+
-- | OXY2DEV/markview.nvim: Markdown Render in Neovim        |
-- +---------------------------------------------------------+

local presets = require("markview.presets")
local filetypes = { "markdown", "codecompanion" }

require("markview").setup({
    preview = {
        filetypes = filetypes,
        icon_provider = "mini",
        modes = { "n", "no", "c" },
        hybrid_modes = { "n" },
        linewise_hybrid_mode = true,
        -- edit_range = { 1, 1 },
        callback = function() end,
    },
    markdown = {},
    latex = {},
})

-- Load the checkboxes module.
require("markview.extras.checkboxes").setup()
vim.keymap.set("n", "X", ":Checkbox toggle<cr>", { desc = "Toggle Checkbox" })

--+- Keymap: Override Descriptions --------------------------+
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "codecompanion" },
    callback = function()
        -- Overwrite description of markview
        vim.keymap.set("n", "gx", "<cmd>Markview Open<cr>", { desc = "Open Link", buffer = 0 })
    end,
})
