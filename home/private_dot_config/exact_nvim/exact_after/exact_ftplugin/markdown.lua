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

-- +- Integration: Treesitter --------------------------------+
-- textobject: code fence
require("nvim-treesitter.configs").setup({
    textobjects = {
        move = {
            goto_next_start = {
                ["]t"] = { query = { "@fenced_code_block.outer" }, desc = "Code Block" },
            },
            goto_previous_start = {
                ["[t"] = { query = { "@fenced_code_block.outer" }, desc = "Code Block" },
            },
        },
    },
})

--+- Integration: MiniAI ------------------------------------+
-- textobject: code fence
vim.b.miniai_config = {
    custom_textobjects = {
        t = require("mini.ai").gen_spec.treesitter({
            a = "@fenced_code_block.outer",
            i = "@code_fence_content",
        }),
    },
}
