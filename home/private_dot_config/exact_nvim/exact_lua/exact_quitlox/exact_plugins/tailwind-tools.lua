-- +---------------------------------------------------------+
-- | luckasRanarison/tailwind-tools: Tailwind Support        |
-- +---------------------------------------------------------+

require("quitlox.util.lazy").on_module("lspconfig", function()
    require("tailwind-tools").setup({
        conceal = {
            enabled = true,
        },
    })
end)

-- Keymaps
vim.keymap.set("n", "[c", "<cmd>TailwindPrevClass<cr>", { noremap = true, silent = true, desc = "Next Tailwind class" })
vim.keymap.set("n", "]c", "<cmd>TailwindNextClass<cr>", { noremap = true, silent = true, desc = "Prev Tailwind class" })
