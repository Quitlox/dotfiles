-- +---------------------------------------------------------+
-- | Automagic Sessions                                      |
-- +---------------------------------------------------------+

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Convert the cwd to a simple file name
local function get_cwd_as_name()
    local dir = vim.fn.getcwd(0)
    return dir:gsub("[^A-Za-z0-9]", "_")
end

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

    -- Save Overseer tasks
    if package.loaded["overseer"] then
        require("overseer").save_task_bundle(
            get_cwd_as_name(),
            -- Passing nil will use config.opts.save_task_opts. You can call list_tasks() explicitly and
            -- pass in the results if you want to save specific tasks.
            nil,
            { on_conflict = "overwrite" } -- Overwrite existing bundle, if any
        )
    end
end

local function pre_restore_hook()
    -- Remove existing Overseer tasks
    if package.loaded["overseer"] then
        for _, task in ipairs(require("overseer").list_tasks({})) do
            task:dispose(true)
        end
    end
end

local function post_restore_hook()
    local session_dir = require("auto-session").get_root_dir()
    local session_name = require("auto-session.lib").current_session_name()

    -- Restore Overseer tasks
    require("overseer").load_task_bundle(get_cwd_as_name(), { ignore_missing = true, autostart = false })
end

return {
    {
        "rmagatti/auto-session",
        dependencies = { "nvim-telescope/telescope.nvim" },
        opts = {
            log_level = "error",
            auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
            auto_session_save_enabled = true,
            auto_session_restore_enabled = true,

            pre_save_cmds = { pre_save_hook },
            post_save_cmds = { post_save_hook },
            pre_restore_cmds = { pre_restore_hook },
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
    },

    require("quitlox.util").legendary({
        { ":SessionSave", "Create or save a session" },
        { ":SessionRestore", "Restore a session" },
        { ":SessionDelete", "Delete a session" },
        { ":SessionPurgeOrphaned", "Delete orphaned sessions" },
        { ":Autosession search", "Search for sessions" },
        { ":Autosession delete", "Delete a session" },
    }),
}
