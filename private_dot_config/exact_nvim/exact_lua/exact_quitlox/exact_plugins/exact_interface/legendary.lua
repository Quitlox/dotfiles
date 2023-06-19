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

--  +----------------------------------------------------------+
--  | Functions                                                |
--  +----------------------------------------------------------+

local functions = {
    -- Log Files
    { function() deleteCacheFile("null-ls.log") end,                         description = "Clear NullLS Log" },
    { function() deleteCacheFile("dap.log") end,                             description = "Clear DAP Log" },
    { function() deleteDataFile("legendary/legendary_frecency.sqlite3") end, description = "Clear Legendary Database" },
    -- Telescope + Vim
    { function() require("telescope.builtin").filetypes() end,               description = "List Filetypes" },
    { function() require("telescope.builtin").registers() end,               description = "List Registers" },
    { function() require("telescope.builtin").vim_options() end,             description = "List Options" },
    { function() require("telescope.builtin").autocommands() end,            description = "List Autocommands" },
    { function() require("telescope.builtin").highlights() end,              description = "List Highlights" },
    { function() require("telescope.builtin").commands() end,                description = "List Commands" },
    { function() require("telescope.builtin").undo() end,                    description = "List Undo" },
}

-- TODO: I think I should swap out using legendary for wilder.nvim
-- Unfortunately, it's currently not possible to pickup Commands and Functions using the Neovim API,
-- meaning that Legendary doesn't have access to them.
-- https://github.com/mrjones2014/legendary.nvim/pull/259
-- Wilder would have access to all Commands, because its the command-line

--  +----------------------------------------------------------+
--  | Plugin Configuration                                     |
--  +----------------------------------------------------------+

return {
    {
        "mrjones2014/legendary.nvim",
        -- version = "",
        -- FIXME: Re-enable when https://github.com/mrjones2014/legendary.nvim/pull/373 released
        dependencies = { "kkharji/sqlite.lua" },
        keys = {
            { "<leader>vk", "<cmd>Legendary<cr>", desc = "Keymap", mode = { "n", "v" } },
        },
        opts = {
            include_builtin = false,
            include_legendary_cmd = true,

            commands = {},
            funcs = functions,

            which_key = {
                auto_register = true,
                do_binding = false,
                use_groups = false,
            },
        },
        extensions = {
            nvim_tree = false,
            smart_splits = true,
            diffview = true,
        },
    },
}
