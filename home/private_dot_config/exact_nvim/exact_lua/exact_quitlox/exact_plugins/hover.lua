-- +---------------------------------------------------------+
-- | lewis6991/hover.nvim: Hover                             |
-- +---------------------------------------------------------+

--+- Neovim Options -----------------------------------------+
vim.o.mousemoveevent = true

--+- Setup --------------------------------------------------+
require("hover").config({
    providers = {
        { module = "hover.providers.fold_preview", priority = 1004 },
        { module = "hover.providers.diagnostic", priority = 1003 },
        { module = "hover.providers.lsp", priority = 1001 },
        { module = "hover.providers.dap", priority = 1001 },
        { module = "hover.providers.man", priority = 150 },
    },
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

local function enter_hover()
    local api = vim.api
    local hover_win = vim.b.hover_preview

    if not hover_win or not api.nvim_win_is_valid(hover_win) then
        require("hover").hover({})
    end

    if hover_win and api.nvim_win_is_valid(hover_win) then
        api.nvim_set_current_win(hover_win)
    end
end

-- stylua: ignore start
vim.keymap.set("n", "K", require('hover').hover, { desc = "Hover" })
vim.keymap.set("n", "gK", enter_hover, { desc = "Hover Enter" })
vim.keymap.set("n", "]h", function() require("hover").hover_switch("next", {}) end, { desc = "Hover" })
vim.keymap.set("n", "[h", function() require("hover").hover_switch("previous", {}) end, { desc = "Hover" })
-- stylua: ignore end
