-- +---------------------------------------------------------+
-- | mrjones2014/legendary.nvim: Command Palette             |
-- +---------------------------------------------------------+

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

--+- Functions ----------------------------------------------+
-- stylua: ignore start
local functions = {
    -- Cleanup
    { function() deleteCacheFile("dap.log") end, description = "Clear DAP Log" },
    { function() deleteDataFile("legendary/legendary_frecency.sqlite3") end, description = "Clear Legendary Database" },
    -- Telescope + Vim
    { function() require("telescope.builtin").registers() end, description = "List Registers" },
    { function() require("telescope.builtin").autocommands() end, description = "List Autocommands" },
    { function() require("telescope.builtin").highlights() end, description = "List Highlights" },
    { function() require("telescope.builtin").undo() end, description = "List Undo" },
}
-- stylua: ignore end

--+- Legendary ----------------------------------------------+
-- TODO: I think I should swap out using legendary for wilder.nvim
-- Unfortunately, it's currently not possible to pickup Commands and Functions using the Neovim API,
-- meaning that Legendary doesn't have access to them.
-- https://github.com/mrjones2014/legendary.nvim/pull/259
-- Wilder would have access to all Commands, because its the command-line

require("legendary").setup({
    include_builtin = false,
    include_legendary_cmd = true,

    funcs = functions,

    extensions = {
        lazy_nvim = false,
        nvim_tree = true,
        diffview = true,
        which_key = {
            auto_register = true,
            do_binding = false,
            use_groups = false,
        },
    },
})

--+- Keymaps ------------------------------------------------+
vim.keymap.set({ "n", "v" }, "<leader>vk", "<cmd>Legendary functions commands<cr>", { noremap = true, silent = true })
