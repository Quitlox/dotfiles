local M = {}

local conf = {}

-- Helper function to check if a module is available
local function has_module(module)
    return package.loaded[module] ~= nil or pcall(require, module)
end

-- Helper function to check if a buffer is a neotest-summary buffer
local function is_neotest_buf(bufnr)
    local status, ft = pcall(vim.api.nvim_buf_get_option_value, bufnr, "filetype", {})
    return status and ft == "neo-tree"
end

-- Helper function to find a neotest-summary window in the current tab
local function find_neotest_win()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if is_neotest_buf(buf) then
            return win
        end
    end
    return nil
end

M.on_save = function()
    if not has_module("neo-tree") then
        return {}
    end

    local neotest_win = find_neotest_win()
    local is_open = neotest_win ~= nil

    -- Close neo-tree summary if it's open
    if is_open then
        pcall(require("neo-tree.command").execute, { action = "close" })
    end

    -- Return whether neo-tree was open
    return { is_open = is_open }
end

M.on_post_load = function(data)
    if not has_module("neotest") then
        return
    end

    -- If neo-tree was open when the session was saved, reopen it
    if data and data.is_open then
        pcall(require("neo-tree.command").execute, { action = "open" })
    end
end

return M
