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
local function hover_or_enter()
    local api = vim.api
    local hover_win = vim.b.hover_preview

    if hover_win and api.nvim_win_is_valid(hover_win) then
        api.nvim_set_current_win(hover_win)
    else
        require("hover").hover({})
    end
end

vim.keymap.set("n", "K", hover_or_enter, { desc = "Hover" })
