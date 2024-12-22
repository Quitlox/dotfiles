-- +---------------------------------------------------------+
-- | luka-reineke/indent-blankline.nvim: Indent Highlight    |
-- +---------------------------------------------------------+
-- May want to look into: shellRaining/hlchunk.nvim, which is supposed to be faster

-- Options
local opts = {
    exclude = { filetypes = { "dashboard" } },
    scope = {
        show_end = false,
    },
    indent = {
        tab_char = "▎",
    },
}

-- Integration with rainbow-delimiters.nvim
local highlight = { "RainbowBlue", "RainbowCyan", "RainbowViolet", "RainbowYellow", "RainbowOrange", "RainbowRed", "RainbowGreen" }
local hooks = require("ibl.hooks")
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

vim.g.rainbow_delimiters = { highlight = highlight }
opts.scope.highlight = highlight

-- Setup
require("ibl").setup(opts)

-- Integration with rainbow-delimiters.nvim
hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
