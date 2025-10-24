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
Snacks.toggle
    .new({
        name = "Hard Wrap",
        get = function()
            return require("wrapping").get_current_mode() == "hard"
        end,
        set = function(state)
            if state then
                require("wrapping").hard_wrap_mode()
            else
                require("wrapping").soft_wrap_mode()
            end
        end,
        notify = false,
    })
    :map("<leader>Tw")
