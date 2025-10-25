-- +---------------------------------------------------------+
-- | dnlhc/glance.nvim: Code Lens                            |
-- +---------------------------------------------------------+

local open_definition_jump_or_glance = function()
    require("glance").open("definitions", {
        hooks = {
            before_open = function(results, open, jump, method)
                if #results == 1 then
                    jump(results[1])
                else
                    open(results)
                end
            end,
        },
    })
end

local open_definition_existing_win_or_peek = function()
    vim.lsp.buf.definition({
        on_list = function(results)
            local single_result = results and results.items and #results.items == 1
            local destination_open_in_other_existing_win = false
            if single_result then
                local dest_filename = results.items[1].filename
                local curr_buf = vim.api.nvim_get_current_buf()
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    if vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win)) == dest_filename and vim.api.nvim_win_get_buf(win) ~= curr_buf then
                        destination_open_in_other_existing_win = true
                        break
                    end
                end
            end

            if single_result and destination_open_in_other_existing_win then
                vim.lsp.buf.definition({ reuse_win = true })
            else
                require("glance").open("definitions")
            end
        end,
    })
end

local actions = require("glance").actions
---@diagnostic disable-next-line: missing-fields
require("glance").setup({
    mappings = {
        list = {
            ["<leader>l"] = false,
            ["i"] = actions.enter_win("preview"),
            ["<C-t>"] = actions.quickfix,
        },
        preview = {
            ["Q"] = actions.close,
            ["<leader>l"] = false,
            ["q"] = actions.enter_win("list"),
            ["<C-t>"] = actions.quickfix,
        },
    },
    use_trouble_qf = true,
})

vim.keymap.set("n", "gd", open_definition_jump_or_glance, { desc = "Go Definition" })
vim.keymap.set("n", "gD", open_definition_existing_win_or_peek, { desc = "Go Definition" })
vim.keymap.set("n", "gri", "<CMD>Glance implementations<CR>", { desc = "Go Implementation" })
vim.keymap.set("n", "grt", "<CMD>Glance type_definitions<CR>", { desc = "Go Type Definition" })
vim.keymap.set("n", "grr", "<CMD>Glance references<CR>", { desc = "Go References" })

-- FIXME:
-- Error executing vim.schedule lua callback: ...im/site/pack/rocks/start/glance.nvim/lua/glance/init.lua:498: Cursor position outside b uffer
-- stack traceback:
--         [C]: in function 'nvim_win_set_cursor'
--         ...im/site/pack/rocks/start/glance.nvim/lua/glance/init.lua:498: in function 'scroll_into_view'
--         ...im/site/pack/rocks/start/glance.nvim/lua/glance/init.lua:443: in function 'create'
--         ...im/site/pack/rocks/start/glance.nvim/lua/glance/init.lua:171: in function 'create'
--         ...im/site/pack/rocks/start/glance.nvim/lua/glance/init.lua:271: in function '_open'
--         ...im/site/pack/rocks/start/glance.nvim/lua/glance/init.lua:295: in function 'handler'
--         /usr/share/nvim/runtime/lua/vim/lsp/client.lua:679: in function ''
--         vim/_editor.lua: in function <vim/_editor.lua:0>
