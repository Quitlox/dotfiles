-- +---------------------------------------------------------+
-- | stevearc/oil.nvim                                       |
-- +---------------------------------------------------------+

--- Should be called after saving an oil buffer.
---
--- This function will check if all open buffers still match a file on disk.
--- If the file on disk has been deleted, and the buffer is unmodified, delete the buffer.
local function on_save_callback()
    -- Use a small delay to ensure file operations are complete
    vim.defer_fn(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local path = vim.api.nvim_buf_get_name(buf)
            if not path or path == "" then
                goto continue
            end
            if vim.startswith(path, "oil://") then
                goto continue
            end

            -- Normalize path for more reliable checking
            local normalized_path = vim.fn.fnamemodify(path, ":p")
            if not vim.loop.fs_stat(normalized_path) then
                vim.schedule(function()
                    require("snacks").bufdelete(buf)
                end)
            end

            ::continue::
        end
    end, 100) -- 100ms delay to give the filesystem time to update
end

--+- Setup --------------------------------------------------+
require("oil").setup({
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    watch_for_changes = true,
    keymaps = {
        ["q"] = "actions.close",
        ["<esc>"] = "actions.close",
        ["<C-s>"] = { callback = require("oil").save, desc = "Commit the changes", mode = "n" },
        ["<C-b>"] = "actions.select_vsplit",
        ["<C-v>"] = "actions.select_split",
        ["<C-h>"] = false,
    },
})

-- Run on_save_callback when saving an oil buffer through :w
vim.api.nvim_create_autocmd("BufLeave", {
    group = vim.api.nvim_create_augroup("OilOnSave", { clear = true }),
    desc = "Clean up buffers for deleted files after saving oil buffer",
    callback = function(event)
        local filetype = vim.api.nvim_get_option_value("filetype", { buf = event.buf })
        if filetype == "oil_preview" then
            vim.notify("Cleaning up deleted files after saving oil buffer", "info")
            on_save_callback()
        end
    end,
})

--+- Keymaps ------------------------------------------------+
-- stylua: ignore start
vim.keymap.set("n", "-", function() require("oil").open_float() end, { noremap = true, silent = true })
vim.keymap.set("n", "_", function() require("oil").open() end, { noremap = true, silent = true })

--+- Commands -----------------------------------------------+
vim.api.nvim_create_user_command("Oil", function() require("oil").open_float() end, { desc = "oil: Open" })
vim.api.nvim_create_user_command("OilBuf", function() require("oil").open() end, { desc = "oil: Open (as Buffer)" })
vim.api.nvim_create_user_command("OilRoot", function() require("oil").open_float(vim.fn.getcwd()) end, { desc = "oil: Open in project root" })
vim.api.nvim_create_user_command("OilDiscard", function() require("oil").discard_all_changes() end, { desc = "oil: Discard changes" })
-- stylua: ignore end
