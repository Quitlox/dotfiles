local function dismissNotifications() require("notify").dismiss({ pending = true, silent = true }) end


local function deleteCacheFile(path)
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

--  +----------------------------------------------------------+
--  | Commands                                                 |
--  +----------------------------------------------------------+

local commands = {
    {
        ":DismissNotifications",
        dismissNotifications,
        description = "Dismiss all notifications",
    },
    {
        ":Gitignore",
        description = "Create .gitignore file",
    },
}

--  +----------------------------------------------------------+
--  | Functions                                                |
--  +----------------------------------------------------------+

local functions = {
    -- Log Files
    { function() deleteCacheFile("null-ls.log") end, description = "Clear NullLS Log" },
    { function() deleteCacheFile("dap.log") end, description = "Clear DAP Log" },
    -- Telescope + Vim
    { function() require("telescope.builtin").filetypes() end, description = "List Filetypes" },
    { function() require("telescope.builtin").registers() end, description = "List Registers" },
    { function() require("telescope.builtin").vim_options() end, description = "List Options" },
    { function() require("telescope.builtin").autocommands() end, description = "List Autocommands" },
    { function() require("telescope.builtin").highlights() end, description = "List Highlights" },
    { function() require("telescope.builtin").commands() end, description = "List Commands" },
    { function() require("telescope.builtin").undo() end, description = "List Undo" },
}

return {
    {
        "mrjones2014/legendary.nvim",
        -- version = "",
        -- TODO: Re-enable when https://github.com/mrjones2014/legendary.nvim/pull/373 released
        dependencies = { "kkharji/sqlite.lua" },
        config = function()
            require("legendary").setup({
                -- funcs = functions,
                -- commands = commands,
                which_key = {
                    auto_register = true,
                    do_binding = false,
                    use_groups = false,
                },
            })

            require("which-key").register({
                k = { "<cmd>Legendary<cr>", "Keymap" },
                d = { "<cmd>DismissNotifications<cr>", "Dismiss Notifications" },
            }, { prefix = "<leader>v" })
        end,
        extensions = {
            nvim_tree = false,
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
