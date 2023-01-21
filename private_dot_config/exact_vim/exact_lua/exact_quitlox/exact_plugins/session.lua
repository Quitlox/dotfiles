vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions,globals"
-- globals -> used by BufferLine to store the order of buffers

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

    -- Close Neogit on Store
    import("neogit.status", function(neogit_status)
        neogit_status.close()
    end)

    -- Close terminals on Store
    import({"toggleterm.terminal"}, function(terminal)
        local terminals = terminal.get_all(true)
        for _, term in pairs(terminals) do
            term:close()
        end
    end)

    -- TODO: Close GitDiff on Store
end

----------------------------------------
-- Project Manager: projections
----------------------------------------

import({ "projections", "telescope", "which-key" }, function(modules)
    local projections = modules.projections
    local telescope = modules.telescope
    local wk = modules["which-key"]

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
    -- TODO: Open Telescope with a prettier, smaller UI
    -- See porjections.nvim for inspiration
    wk.register({ p = { "<cmd>Telescope projections<cr>", "Open Projects" } }, { prefix = "<leader>o" })
    wk.register({ o = { "<cmd>Telescope projections<cr>", "Project Open" } }, { prefix = "<leader>p" })

    -- Command for adding additional projects to workspace
    local Workspace = require("projections.workspace")
    vim.api.nvim_create_user_command("AddWorkspace", function() Workspace.add(vim.loop.cwd()) end, {})
    wk.register({ a = { "<cmd>AddWorkspace<cr>", "Project Add" } }, { prefix = "<leader>p" })

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

----------------------------------------
-- Workaround
----------------------------------------
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
