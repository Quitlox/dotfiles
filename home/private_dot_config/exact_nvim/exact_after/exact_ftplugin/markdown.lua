-- +- Custom keybindings -------------------------------------+
vim.keymap.set("v", "<C-b>", "xi****<Esc>hhp", { desc = "Markdown Bold", buffer = 0 })
vim.keymap.set("v", "<C-e>", "xi**<Esc>hp", { desc = "Markdown Italic", buffer = 0 })
vim.keymap.set("i", "<C-e>", "**<Esc>i", { desc = "Markdown Italic", buffer = 0 })
vim.keymap.set("i", "<C-b>", "****<C-o>h", { desc = "Markdown Bold", buffer = 0 })

-- +- Integration: VimTex ------------------------------------+
-- Initialize VimTeX for LaTeX math support in markdown
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
-- stylua: ignore start
vim.keymap.set({"n","x","o",},"]t", function() require("nvim-treesitter-textobjects").goto_next_start("@fenced_code_block.outer") end, {desc="Next Codeblock Start"})
vim.keymap.set({"n","x","o",},"[t", function() require("nvim-treesitter-textobjects").goto_previous_start("@fenced_code_block.outer") end, {desc="Previous Codeblock Start"})
-- stylua: ignore end

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
