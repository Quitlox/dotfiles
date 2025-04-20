-- +---------------------------------------------------------+
-- | luckasRanarison/tailwind-tools: Tailwind Support        |
-- +---------------------------------------------------------+

local tailwind_ft = { "html", "css", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte", "astro", "php" }

require("quitlox.util.lazy").on_module("lspconfig", function()
    require("tailwind-tools").setup({
        conceal = {
            enabled = true,
        },
    })
end)

-- Set up Tailwind keymaps for relevant filetypes
vim.api.nvim_create_autocmd("FileType", {
    pattern = tailwind_ft,
    group = vim.api.nvim_create_augroup("TailwindToolsKeymaps", { clear = true }),
    desc = "Set Tailwind keymaps for relevant filetypes",
    callback = function()
        vim.keymap.set("n", "[c", "<cmd>TailwindPrevClass<cr>", { buffer = 0, noremap = true, silent = true, desc = "Prev Tailwind class" })
        vim.keymap.set("n", "]c", "<cmd>TailwindNextClass<cr>", { buffer = 0, noremap = true, silent = true, desc = "Next Tailwind class" })
    end,
})
