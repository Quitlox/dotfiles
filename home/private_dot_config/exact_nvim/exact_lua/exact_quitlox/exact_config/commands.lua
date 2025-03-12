-- :W saves file using sudo
vim.api.nvim_create_user_command("W", "execute 'w !sudo tee % > /dev/null' <bar> edit!", { bang = true })

--+- Helper Functions ---------------------------------------+
local function deleteFile(path)
    local success, err = os.remove(path)
    local notify = require("notify")

    if success then
        notify("Removed " .. path .. " successfully.", "info", {})
    else
        notify("Error removing " .. path .. ": " .. tostring(err), "error", {})
    end
end

local function deleteCacheFile(path)
    local cache_dir = vim.fn.stdpath("cache")
    local file_path = cache_dir .. "/" .. path
    deleteFile(file_path)
end

local function deleteDataFile(path)
    local cache_dir = vim.fn.stdpath("data")
    local file_path = cache_dir .. "/" .. path
    deleteFile(file_path)
end

--+- Utility Commands ---------------------------------------+
-- stylua: ignore
vim.api.nvim_create_user_command("DeleteDapLog", function() deleteCacheFile("dap.log") end, { desc = "Delete DAP Log" })
