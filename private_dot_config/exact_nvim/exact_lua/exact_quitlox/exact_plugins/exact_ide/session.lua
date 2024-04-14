-- +---------------------------------------------------------+
-- | Automagic Sessions                                      |
-- +---------------------------------------------------------+
-- NOTE: Posession has built-in support for various plugins, which might make it worth to switch over to.

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Convert the cwd to a simple file name
local function get_cwd_as_name()
    local dir = vim.fn.getcwd(0)
    return dir:gsub("[^A-Za-z0-9]", "_")
end

local plugin_state = {
    neo_tree = false,
}

local function pre_save_hook()
    -- Save the current state of the plugins
    plugin_state.neo_tree = require("quitlox.util").is_neotree_open()

    -- Close all open plugins
    if package.loaded["neo-tree"] then
        vim.cmd("Neotree action=close")
    end
    if package.loaded["neotest"] then
        require("neotest").output_panel.close()
        require("neotest").summary.close()
    end
    if package.loaded["edgy"] then
        require("edgy").close()
    end
    if package.loaded["dapui"] then
        require("dapui").close()
    end
    if package.loaded["diffview"] then
        vim.cmd([[DiffviewClose]])
    end
    if package.loaded["neogit"] then
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "NeogitStatus" then
                vim.api.nvim_win_close(win, true)
            end
        end
    end
    if package.loaded["toggleterm"] then
        for _, term in pairs(require("toggleterm.terminal").get_all(true)) do
            term:close()
        end
    end

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        -- Close all directory buffers
        if vim.bo[buf].buftype == "dirvish" then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
        -- Close all notify buffers
        if vim.bo[buf].buftype == "notify" then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
        -- Close all octo buffers
        if string.match(vim.api.nvim_buf_get_name(buf), "octo://.+") then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
        if string.match(vim.api.nvim_buf_get_name(buf), "OctoChangedFiles.+") then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
    end
end

local function save_extra_cmds()
    return {
        function()
            if plugin_state.neo_tree then
                return [[execute 'lua require("neo-tree.command").execute({action="focus", source="filesystem", position="left"})']]
            end
        end,
    }
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

    -- Source Python virtual environment
    -- local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
    -- if venv ~= "" then require("venv-selector").retrieve_from_cache() end

    local venv_name = require("venv-selector").get_active_venv()
    if venv_name ~= nil then
        require("venv-selector").retrieve_from_cache()
    end
    -- Restore Overseer tasks
    require("overseer").load_task_bundle(get_cwd_as_name(), { ignore_missing = true, autostart = false })
end

return {
    {
        "rmagatti/auto-session",
        -- FIXME: Ensure that session is deleted on fail
        opts = {
            log_level = "error",
            auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
            auto_save_enabled = true,
            auto_restore_enabled = false,
            auto_session_use_git_branch = true,

            save_extra_cmds = save_extra_cmds(),
            pre_save_cmds = { pre_save_hook },
            post_save_cmds = { post_save_hook },
            pre_restore_cmds = { pre_restore_hook },
            post_restore_cmds = { post_restore_hook },

            session_lens = {
                load_on_setup = false,
                theme_conf = { border = true },
                previewer = false,
            },
        },
        lazy = false,
        keys = {
            {
                "<leader>fs",
                function()
                    require("auto-session").setup_session_lens()
                    require("auto-session.session-lens").search_session()
                end,
                desc = "Find Sessions",
            },
        },
        config = function(_, opts)
            require("auto-session").setup(opts)
            -- require("telescope").load_extension("session-lens")
        end,
    },
    require("quitlox.util").legendary({
        { ":SessionSave", "Create or save a session" },
        { ":SessionRestore", "Restore a session" },
        { ":SessionDelete", "Delete a session" },
        { ":SessionPurgeOrphaned", "Delete orphaned sessions" },
        { ":Autosession search", "Search for sessions" }, -- FIXME: Doesn't work
        { ":Autosession delete", "Delete a session" }, -- FIXME: Doesn't work
    }),
}
