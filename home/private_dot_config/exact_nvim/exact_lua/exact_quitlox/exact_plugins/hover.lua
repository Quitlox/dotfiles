-- +---------------------------------------------------------+
-- | lewis6991/hover.nvim: Hover                             |
-- +---------------------------------------------------------+

vim.o.mousemoveevent = true

require("hover").setup({
    init = function()
        -- Require providers
        require("hover.providers.lsp")
        require("hover.providers.dap")
        require("hover.providers.fold_preview")
        require("hover.providers.diagnostic")
        require("hover.providers.man")
    end,
})

-- vim.keymap.set("n", "gh", "<cmd>lua require('hover').hover()<cr>", { desc = "Hover" })
vim.keymap.set("n", "K", "<cmd>lua require('hover').hover()<cr>", { desc = "Hover" })
vim.keymap.set("n", "gK", "<cmd>lua require('hover').hover_select()<cr>", { desc = "Hover Select" })
