-- +---------------------------------------------------------+
-- | ziontee133/icon-picker.nvim: Icon Picker                |
-- +---------------------------------------------------------+

vim.g.initialized_icon_picker = 0

--+- Setup --------------------------------------------------+
local function setup_icon_picker()
    if vim.g.initialized_icon_picker == 1 then return end

    require("icon-picker").setup({
        disable_legacy_commands = true,
    })

    vim.g.initialized_icon_picker = 1
end

vim.keymap.set("n", "<leader>oi", "<cmd>IconPickerNormal alt_font symbols nerd_font_v3 emoji<cr>", { noremap = true, silent = true })

require("quitlox.util.lazy").command_stub_args("IconPickerNormal", setup_icon_picker)
require("quitlox.util.lazy").command_stub_args("IconPickerInsert", setup_icon_picker)
require("quitlox.util.lazy").command_stub_args("IconPickerYank", setup_icon_picker)

--+- Commands -----------------------------------------------+
require("legendary").commands({
    { ":IconPickerNormal alt_font symbols nerd_font_v3 emoji", description = "Open Icon Picker" },
    { ":IconPickerYank alt_font symbols nerd_font_v3 emoji", description = "Open Icon Picker (Yank)" },
})
