local M = {}

-- Helper function to check if a module is available
local function has_module(module)
    return package.loaded[module] ~= nil or pcall(require, module)
end

-- This function runs before saving a session
M.on_save = function()
    if not has_module("arrow") then
        return {}
    end

    local arrow_data = {}

    -- Get file bookmarks
    arrow_data.filenames = vim.deepcopy(vim.g.arrow_filenames or {})

    -- Get buffer bookmarks
    local buffer_persist = require("arrow.buffer_persist")
    arrow_data.buffer_bookmarks = {}

    -- Save bookmarks for each buffer
    for bufnr, bookmarks in pairs(buffer_persist.local_bookmarks) do
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname and bufname ~= "" then
            arrow_data.buffer_bookmarks[bufname] = vim.deepcopy(bookmarks)
        end
    end

    -- Get arrow.nvim config state
    local config = require("arrow.config")
    arrow_data.config_state = {
        save_key_cached = config.getState("save_key_cached"),
        current_branch = config.getState("current_branch"),
    }

    return arrow_data
end

-- This function runs after loading a session
M.on_post_load = function(data)
    if not has_module("arrow") or not data then
        return
    end

    -- Restore file bookmarks
    if data.filenames then
        vim.g.arrow_filenames = vim.deepcopy(data.filenames)
    end

    -- Restore config state
    if data.config_state then
        local config = require("arrow.config")
        for key, value in pairs(data.config_state) do
            config.setState(key, value)
        end
    end

    -- Restore buffer bookmarks
    if data.buffer_bookmarks then
        local buffer_persist = require("arrow.buffer_persist")

        -- Clear the current state
        buffer_persist.local_bookmarks = {}
        buffer_persist.last_sync_bookmarks = {}

        -- Wait a bit for buffers to load
        vim.defer_fn(function()
            -- Restore bookmarks for each buffer
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                local bufname = vim.api.nvim_buf_get_name(buf)
                if bufname and bufname ~= "" and data.buffer_bookmarks[bufname] then
                    buffer_persist.local_bookmarks[buf] = vim.deepcopy(data.buffer_bookmarks[bufname])

                    -- Redraw bookmarks in the buffer
                    if vim.api.nvim_buf_is_loaded(buf) then
                        buffer_persist.clear_buffer_ext_marks(buf)
                        buffer_persist.redraw_bookmarks(buf, buffer_persist.local_bookmarks[buf])
                    end
                end
            end
        end, 100) -- Short delay to ensure buffers are loaded
    end

    -- Trigger the ArrowUpdate event
    vim.api.nvim_exec_autocmds("User", {
        pattern = "ArrowUpdate",
    })

    -- Trigger the ArrowMarkUpdate event
    vim.api.nvim_exec_autocmds("User", {
        pattern = "ArrowMarkUpdate",
    })
end

return M
