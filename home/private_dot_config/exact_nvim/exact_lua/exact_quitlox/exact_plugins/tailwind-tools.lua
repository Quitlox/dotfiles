-- +---------------------------------------------------------+
-- | luckasRanarison/tailwind-tools: Tailwind Support        |
-- +---------------------------------------------------------+

-- Setup
require("tailwind-tools").setup({
    conceal = {
        enabled = true,
    },
})

-- Keymaps
vim.keymap.set("n", "[c", "<cmd>TailwindPrevClass<cr>", { noremap = true, silent = true, desc = "Next Tailwind class" })
vim.keymap.set("n", "]c", "<cmd>TailwindNextClass<cr>", { noremap = true, silent = true, desc = "Prev Tailwind class" })

-- Commands
require("legendary").commands({
    -- { ":TailwindConcealEnable", description = "Enables conceal for all buffers." },
    -- { ":TailwindConcealDisable", description = "Disables conceal." },
    { ":TailwindConcealToggle", description = "Toggles conceal." },
    -- { ":TailwindColorEnable", description = "Enables color hints for all buffers." },
    -- { ":TailwindColorDisable", description = "Disables color hints." },
    { ":TailwindColorToggle", description = "Toggles color hints." },
    { ":TailwindSort", description = "Sorts all classes in the current buffer." },
    { ":TailwindSortSelection", description = "Sorts selected classes in visual mode." },
})
