-- +- Integration: VimTex ------------------------------------+
vim.cmd([[call vimtex#init()]])

-- +- Integration: Luasnip - Detect Snippets in Embeds -------+
require("luasnip").setup({
    enable_autosnippets = true,
    ft_func = require("luasnip.extras.filetype_functions").from_cursor_pos,
    load_ft_func = require("luasnip.extras.filetype_functions").extend_load_ft({
        markdown = { "tex", "latex" },
    }),
})
