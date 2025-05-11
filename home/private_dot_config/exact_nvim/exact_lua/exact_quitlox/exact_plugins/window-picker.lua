-- +---------------------------------------------------------+
-- | s1n7ax/nvim-window-picker: Window Picker                |
-- +---------------------------------------------------------+

require("window-picker").setup({ hint = "floating-big-letter" })

--+- Keymap -------------------------------------------------+
vim.keymap.set("n", "<c-w>g", function()
    local picked_window_id = require("window-picker").pick_window()
    if picked_window_id then
        vim.api.nvim_set_current_win(picked_window_id)
    end
end, { desc = "Jump with Picker" })
