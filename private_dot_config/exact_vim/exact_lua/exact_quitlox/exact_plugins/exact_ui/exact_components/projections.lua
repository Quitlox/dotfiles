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

----------------------------------------------------------------------
--          Sessions + Projects Manager: projections.nvim           --
----------------------------------------------------------------------

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions,globals"
-- globals -> used by BufferLine to store the order of buffers

-- Autocmd group
local augroup = vim.api.nvim_create_augroup("Projections", { clear = true })

-- Hook to run when a session is restored
local function restore_hook()
    -- Refresh NvimTree using the current working directory
    local tree = require("nvim-tree.api").tree
    tree.change_root(vim.fn.getcwd())
    tree.reload()
    tree.open()
end

-- Hook to run when a session is stored
local function store_hook()
    -- Close DapUI on Store
    require("dapui").close({})
    -- Close Neogit on Store
    require("neogit.status").close()
    -- Close ToggleTerm on Store
    for _, term in pairs(require("toggleterm.terminal").get_all(true)) do
        term:close()
    end

    -- TODO: Close GitDiff on Store
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
            "/home/quitlox/Workspace/hobby",
            "/home/quitlox/Workspace/study",
            "/home/quitlox/Workspace/contrib",
            "/home/quitlox/Workspace/activism",
            "/home/quitlox/Workspace/activism/yorinf",
            "/home/quitlox/Workspace/overleaf",
            { "/home/quitlox/.config", { "vimrc" } },
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

        -- Command for adding additional projects to workspace
        local Workspace = require("projections.workspace")
        vim.api.nvim_create_user_command("AddWorkspace", function() Workspace.add(vim.loop.cwd()) end, {})

        -- Autostore session on VimExit
        local session = require("projections.session")
        vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
            callback = function() session.store(vim.loop.cwd()) end,
            group = augroup,
        })

        -- Switch to project if vim was started in a project dir
        local switcher = require("projections.switcher")
        vim.api.nvim_create_autocmd({ "VimEnter" }, {
            group = augroup,
            callback = function()
                if vim.fn.argc() == 0 then switcher.switch(vim.loop.cwd()) end
            end,
        })
    end,
    init = function()
        -- Keybindings
        require("which-key").register({
            p = {
                name = "Project",
                a = { "<cmd>AddWorkspace<cr>", "Project Add" },
                o = { "<cmd>Telescope projections<cr>", "Project Open" },
                s = { name = "Session", d = { delete_session, "Project Session Delete" } },
            },
        }, { prefix = "<leader>" })
    end,
}
