-- +---------------------------------------------------------+
-- | L3MON4D3/LuaSnip: Snippet Enginge                       |
-- +---------------------------------------------------------+

-- Load snippets
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })

-- Stop snippets session upon going to normal mode
vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "*",
    callback = function()
        if
            ((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
            and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
            and not require("luasnip").session.jump_active
        then
            require("luasnip").unlink_current()
        end
    end,
})
