-- +---------------------------------------------------------+
-- | lewis6991/hover.nvim: Hover                             |
-- +---------------------------------------------------------+

--+- Neovim Options -----------------------------------------+
vim.o.mousemoveevent = true

--+- Setup --------------------------------------------------+
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

--+- Keymaps ------------------------------------------------+
vim.keymap.set("n", "K", "<cmd>lua require('hover').hover()<cr>", { desc = "Hover" })
vim.keymap.set("n", "gK", "<cmd>lua require('hover').hover_select()<cr>", { desc = "Hover Select" })
