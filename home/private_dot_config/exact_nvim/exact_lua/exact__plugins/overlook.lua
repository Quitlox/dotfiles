-- +---------------------------------------------------------+
-- | WilliamHsieh/overlook.nvim                              |
-- +---------------------------------------------------------+

-- Picks the first result that isn't the current cursor position and peeks it.
-- rust-analyzer returns the current position as the "definition" for methods
-- inside `impl Trait for Type` blocks, so we filter those self-refs out.
local function peek_first(create_popup, tt, on_empty)
    local cur_uri = vim.uri_from_bufnr(0)
    local cur_line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local item = vim.tbl_filter(function(it)
        local uri = it.user_data.targetUri or it.user_data.uri
        return not (uri == cur_uri and (it.lnum - 1) == cur_line)
    end, tt.items)[1]
    if not item then
        if on_empty then on_empty() end
        return
    end
    create_popup({
        target_bufnr = vim.uri_to_bufnr(item.user_data.targetUri or item.user_data.uri),
        lnum = item.lnum,
        col = item.col,
        title = item.filename,
    })
end

-- Override overlook's built-in `definition` adapter: try definition first,
-- and if every result is self-referential, fall back to declaration
-- (which, for trait impl methods, points at the trait's method declaration).
require("overlook").setup({
    adapters = {
        definition = {
            async = true,
            async_create_popup = function(create_popup)
                vim.lsp.buf.definition({
                    on_list = function(tt)
                        peek_first(create_popup, tt, function()
                            vim.lsp.buf.declaration({
                                on_list = function(dt) peek_first(create_popup, dt) end,
                            })
                        end)
                    end,
                })
            end,
        },
    },
})

-- stylua: ignore start
vim.keymap.set("n", "gD", function() require("overlook.api").peek_definition() end, { desc = "Overlook: Peek definition" })
vim.keymap.set("n", "<leader>pu", function() require("overlook.api").restore_popup() end, { desc = "Overlook: Restore popup" })
vim.keymap.set("n", "<leader>pr", function() require("overlook.api").restore_all_popups() end, { desc = "Overlook: Restore all popups" })
-- stylua: ignore end
