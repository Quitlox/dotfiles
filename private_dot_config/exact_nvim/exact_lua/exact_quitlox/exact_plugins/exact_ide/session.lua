-- +---------------------------------------------------------+
-- | Automagic Sessions                                      |
-- +---------------------------------------------------------+

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

local function pre_save_hook()
    if package.loaded["neo-tree"] then vim.cmd("Neotree action=close") end
    if package.loaded["neotest"] then
        require("neotest").output_panel.close()
        require("neotest").summary.close()
    end
    if package.loaded["edgy"] then require("edgy").close() end
    if package.loaded["dapui"] then require("dapui").close() end
    if package.loaded["diffview"] then vim.cmd([[DiffviewClose]]) end
    if package.loaded["neogit"] then
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "NeogitStatus" then vim.api.nvim_win_close(win, true) end
        end
    end
    if package.loaded["toggleterm"] then
        for _, term in pairs(require("toggleterm.terminal").get_all(true)) do
            term:close()
        end
    end

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        -- Close all directory buffers
        if vim.bo[buf].buftype == "dirvish" then vim.api.nvim_buf_delete(buf, { force = true }) end
        -- Close all notify buffers
        if vim.bo[buf].buftype == "notify" then vim.api.nvim_buf_delete(buf, { force = true }) end
    end
end

local function post_save_hook()
    local session_dir = require("auto-session").get_root_dir()
    local session_name = require("auto-session.lib").current_session_name()
end

local function post_restore_hook()
    local session_dir = require("auto-session").get_root_dir()
    local session_name = require("auto-session.lib").current_session_name()
end

return {
    "rmagatti/auto-session",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
        auto_session_save_enabled = true,
        auto_session_restore_enabled = true,

        pre_save_cmds = { pre_save_hook },
        post_save_cmds = { post_save_hook },
        post_restore_cmds = { post_restore_hook },

        session_lens = {
            load_on_setup = true,
            theme_conf = { border = true },
            previewer = false,
        },
    },
    lazy = false,
    keys = {
        { "<leader>fs", "<cmd>lua require('auto-session.session-lens').search_session", desc = "Find Sessions" },
    },
    config = function(_, opts)
        require("telescope").load_extension("session-lens")
        require("auto-session").setup(opts)
    end,
    init = function()
        require("legendary").commands({
            { ":SessionSave", description = "Create or save a session" },
            { ":SessionRestore", description = "Restore a session" },
            { ":SessionDelete", description = "Delete a session" },
            { ":SessionPurgeOrphaned", description = "Delete orphaned sessions" },
            { ":Autosession search", description = "Search for sessions" },
            { ":Autosession delete", description = "Delete a session" },
        })
    end,
}
