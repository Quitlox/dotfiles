-- +---------------------------------------------------------+
-- | stevearc/oil.nvim                                       |
-- +---------------------------------------------------------+

--- Should be called after saving an oil buffer.
---
--- This function will check if all open buffers still match a file on disk.
--- If the file on disk has been deleted, and the buffer is unmodified, delete the buffer.
function on_save_callback()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local path = vim.api.nvim_buf_get_name(buf)
        if not path or path == "" then
            goto continue
        end
        if vim.startswith(path, "oil://") then
            goto continue
        end

        if not vim.loop.fs_stat(path) then
            vim.schedule(function()
                require("snacks").bufdelete(buf)
            end)
        end

        ::continue::
    end

    require("oil").close()
end

--+- Setup --------------------------------------------------+
require("oil").setup({
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    watch_for_changes = true,
    keymaps = {
        ["q"] = "actions.close",
        ["<esc>"] = "actions.close",
        -- stylua: ignore
        ["<C-s>"] = { callback = function() require("oil").save({}, on_save_callback) end, desc = "Commit the changes", mode = "n" },
        ["<C-b>"] = "actions.select_vsplit",
        ["<C-v>"] = "actions.select_split",
        ["<C-h>"] = false,
    },
})

--+- Keymaps ------------------------------------------------+
-- stylua: ignore
vim.keymap.set("n", "-", function() require("oil").open_float() end, { noremap = true, silent = true })

--+- Commands -----------------------------------------------+
vim.api.nvim_create_user_command("Oil", function()
    require("oil").open_float()
end, {
    desc = "oil: Open",
})
vim.api.nvim_create_user_command("OilRoot", function()
    require("oil").open_float(vim.fn.getcwd())
end, {
    desc = "oil: Open in project root",
})
vim.api.nvim_create_user_command("OilDiscard", function()
    require("oil").discard_all_changes()
end, {
    desc = "oil: Discard changes",
})
