vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions,globals"
-- globals -> used by BufferLine to store the order of buffers

-- Workaround
-- https://github.com/rmagatti/auto-session/issues/64
if not vim.fn.has("nvim-0.8.1") == 1 then
    function _G.close_all_floating_wins()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local config = vim.api.nvim_win_get_config(win)
            if config.relative ~= "" then vim.api.nvim_win_close(win, false) end
        end
    end
else
    function _G.close_all_floating_wins() end
end

----------------------------------------
-- Session Manager: auto-session
----------------------------------------

local function restore_nvim_tree()
    -- Refresh NvimTree on Restore
    local tree = require("nvim-tree.api").tree
    tree.change_root(vim.fn.getcwd())
    vim.cmd("NvimTreeRefresh")
    tree.open()
end

local function store_hook()
    -- Close DapUI on Store
    import("dapui", function(module) module.close({}) end)
    -- TODO: Close Neogit on Store
    -- TODO: Close GitDiff on Store
end

-- import("auto-session", function(autosession)
-- 	autosession.setup({
-- 		log_level = "warn",
-- 		auto_session_suppress_dirs = { "~/", "~/Downloads", "~/Documents", "/tmp" },
-- 		pre_save_cmds = { _G.close_all_floating_wins },
-- 		post_restore_cmds = { restore_nvim_tree },
-- 		auto_save_enabled = true,
-- 		auto_restore_enabled = true,
-- 	})
-- end)

----------------------------------------
-- Project Manager: projections
----------------------------------------

import({ "projections", "telescope" }, function(modules)
    local projections = modules.projections
    local telescope = modules.telescope

    -- Setup projections.nvim plugin
    projections.setup({
        workspaces = {
            "/home/quitlox/Workspace/job",
            "/home/quitlox/Workspace/hobby",
            "/home/quitlox/Workspace/study",
            "/home/quitlox/Workspace/contrib",
            "/home/quitlox/Workspace/activism",
            "/home/quitlox/Workspace/activism/yorinf",
            "/home/quitlox/Workspace/overleaf",
            { "/home/quitlox/.config", { "vimrc" } },
        },
        store_hooks = { pre = store_hook },
        restore_hooks = { post = restore_nvim_tree },
    })

    -- Bind telescope keybinding for browsing projects
    telescope.load_extension("projections")
    -- vim.keymap.set("n", "<leader>op", function()
    -- 	vim.cmd("Telescope projections")
    -- end)
    require("which-key").register({
        p = { "<cmd>Telescope projections<cr>", "Open Projects" },
    }, { prefix = "<leader>o" })

    -- Autostore session on VimExit
    local session = require("projections.session")
    vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
        callback = function() session.store(vim.loop.cwd()) end,
    })

    -- Switch to project if vim was started in a project dir
    local switcher = require("projections.switcher")
    vim.api.nvim_create_autocmd({ "VimEnter" }, {
        callback = function()
            if vim.fn.argc() == 0 then switcher.switch(vim.loop.cwd()) end
        end,
    })
end)
