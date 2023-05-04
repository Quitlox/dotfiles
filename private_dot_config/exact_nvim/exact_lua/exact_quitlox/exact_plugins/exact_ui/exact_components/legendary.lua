local function dismissNotifications() require("notify").dismiss({ pending = true, silent = true }) end

function deleteCacheFile(path)
    local cache_dir = vim.fn.stdpath("cache")
    local file_path = cache_dir .. "/" .. path

    local success, err = os.remove(file_path)
    local notify = require("notify")

    if success then
        notify("Removed " .. path .. " successfully.", "info", {})
    else
        notify("Error removing " .. path .. ": " .. tostring(err), "error", {})
    end
end

return {
    {
        "mrjones2014/legendary.nvim",
        version = "",
        dependencies = { "kkharji/sqlite.lua" },
        config = function()
            require("legendary").setup({
                funcs = {
                    {
                        function() deleteCacheFile("null-ls.log") end,
                        description = "Delete the NullLS Log file",
                    },
                    {
                        function() deleteCacheFile("dap.log") end,
                        description = "Delete the DAP Log file",
                    },
                },
                commands = {
                    {
                        ":DismissNotifications",
                        dismissNotifications,
                        description = "Dismiss all notifications",
                    },
                    {
                        ":Gitignore",
                        description = "Create .gitignore file",
                    },
                },
                which_key = {
                    auto_register = true,
                    do_binding = false,
                },
            })

            require("which-key").register({
                k = { "<cmd>Legendary<cr>", "Keymap" },
                d = { "<cmd>DismissNotifications<cr>", "Dismiss Notifications" },
            }, { prefix = "<leader>v" })
        end,
        extensions = {
            nvim_tree = true,
            smart_splits = true,
            diffview = true,
        },
    },
    {
        "wintermute-cell/gitignore.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        cmd = "Gitignore",
        lazy = true,
    },
}
