-- +---------------------------------------------------------+
-- | andrewferrier/wrapping.nvim: Auto Hard/Soft Wrap        |
-- +---------------------------------------------------------+

local filetypes = { "asciidoc", "gitcommit", "mail", "markdown", "rst", "tex", "text" }

-- Setup
require("wrapping").setup({
    create_keymaps = false,
    notify_on_switch = true,
    auto_set_mode_filetype_allowlist = filetypes,
})

-- Automatically set textwidth=80 (in case of hard wrap)
vim.api.nvim_create_autocmd("filetype", {
    group = vim.api.nvim_create_augroup("HardWrapFileType", { clear = true }),
    pattern = filetypes,
    command = "setlocal textwidth=80",
})

-- Toggle
local toggle = {
    name = "Soft Wrap",
    get = function()
        return require("wrapping").get_current_mode() == "soft"
    end,
    set = function(state)
        if state then
            require("wrapping").soft_wrap_mode()
        else
            require("wrapping").hard_wrap_mode()
        end
    end,
}
require("quitlox.util.toggle").map("<leader>Tw", toggle, false)

-- Commands
require("legendary").commands({
    { ":HardWrapMode", description = "wrapping.nvim: toggle hard wrap mode" },
    { ":SoftWrapMode", description = "wrapping.nvim: toggle soft wrap mode" },
    { ":ToggleWrapMode", description = "wrapping.nvim: toggle wrap mode" },
    { ":WrappingOpenLog", description = "wrapping.nvim: open log file" },
})
