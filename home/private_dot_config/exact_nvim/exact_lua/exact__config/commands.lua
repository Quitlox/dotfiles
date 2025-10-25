-- :W saves file using sudo
vim.api.nvim_create_user_command("W", "execute 'w !sudo tee % > /dev/null' <bar> edit!", { bang = true })

--+- Helper Functions ---------------------------------------+
local function deleteFile(path)
    local success, err = vim.fs.rm(path)

    if success then
        require("notify")("Removed " .. path .. " successfully.", "info", {})
    else
        require("notify")("Error removing " .. path .. ": " .. tostring(err), "error", {})
    end
end

--+- Utility Commands ---------------------------------------+
-- stylua: ignore
-- vim.api.nvim_create_user_command("DeleteDapLog", function() deleteFile(vim.fn.stdpath("cache") .. "/" .."dap.log") end, { desc = "Delete DAP Log" })
