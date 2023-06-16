----------------------------------------------------------------------
--          Sessions + Projects Manager: projections.nvim           --
----------------------------------------------------------------------

-- vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions,globals"
vim.opt.sessionoptions:append("localoptions")

-- Autocmd group
local augroup = vim.api.nvim_create_augroup("Projections", { clear = true })

local function restore_hook() end

local function store_hook()
    vim.cmd("NeoTreeClose")
    vim.cmd("SymbolsOutlineClose")
    require('neotest').output_panel.close()
    require('neotest').summary.close()
    require('edgy').close()

    require("dapui").close()
    vim.cmd("DiffviewClose")

    -- Close Neogit
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "NeogitStatus" then vim.api.nvim_win_close(win, true) end
    end
    -- Close ToggleTerm
    for _, term in pairs(require("toggleterm.terminal").get_all(true)) do
        term:close()
    end
end

-- Delete the current session
local function delete_session()
    local Session = require("projections.session")
    local info = Session.info(vim.fn.getcwd())
    if vim.fn.delete(info.path.path) == 0 then
        -- Delete the AutoCommand group to prevent the same
        -- Session file from being recreated
        vim.api.nvim_del_augroup_by_id(augroup)
        vim.notify("Successfully deleted session!\nSession file: " .. info.path.path, vim.log.levels.INFO)
    else
        vim.notify("Could not delete session\nSession file: " .. info.path.path, vim.log.levels.ERROR)
    end
end

return {
    "GnikDroy/projections.nvim",
    opts = {
        workspaces = {
            "/home/quitlox/Workspace/job",
            "/home/quitlox/Workspace/work",
            "/home/quitlox/Workspace/hobby",
            "/home/quitlox/Workspace/study",
            "/home/quitlox/Workspace/contrib",
            "/home/quitlox/Workspace/activism",
            "/home/quitlox/Workspace/activism/yorinf",
            "/home/quitlox/Workspace/overleaf",
            { "/home/quitlox/.config", { "init.lua", "vimrc" } },
        },
        store_hooks = { pre = store_hook },
        restore_hooks = { post = restore_hook },
    },
    config = function(_, opts)
        -- Setup projections.nvim plugin
        require("projections").setup(opts)

        -- Bind telescope keybinding for browsing projects
        require("telescope").load_extension("projections")
        -- TODO: Open Telescope with a prettier, smaller UI
        -- See projections.nvim for inspiration

        -- Autostore session on VimExit
        vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
            callback = function() require("projections.session").store(vim.loop.cwd()) end,
            group = augroup,
        })

        -- Switch to project if vim was started in a project dir
        local switcher = require("projections.switcher")
        vim.api.nvim_create_autocmd({ "VimEnter" }, {
            callback = function()
                if vim.fn.argc() == 0 then switcher.switch(vim.loop.cwd()) end
            end,
        })
    end,
    init = function()
        -- Command for switching projects
        require("legendary").command({
            ":SwitchProject",
            "<cmd>Telescope projections<cr>",
            description = "Switch Project",
        })
        -- Command for deleting session
        require("legendary").command({
            ":DeleteSession",
            delete_session,
            description = "Delete Session",
        })
        -- Command for adding additional projects to workspace
        require("legendary").command({
            ":AddWorkspace",
            function() require("projections.workspace").add(vim.loop.cwd()) end,
            description = "Add the pwd as Workspace",
        })
        -- Command for Storing Session
        require("legendary").command({
            ":StoreSession",
            function() require("projections.session").store(vim.loop.cwd()) end,
            description = "Store Session",
        })
        -- Command for Restoring Session
        require("legendary").command({
            ":RestoreSession",
            function() require("projections.session").restore(vim.loop.cwd()) end,
            description = "Restore Session",
        })
    end,
}
