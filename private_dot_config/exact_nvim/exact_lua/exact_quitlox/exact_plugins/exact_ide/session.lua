----------------------------------------------------------------------
--          Sessions + Projects Manager: projections.nvim           --
----------------------------------------------------------------------

-- Set sessionoptions
vim.opt.sessionoptions:append("localoptions")
-- Autocmd group
local augroup = vim.api.nvim_create_augroup("Projections", { clear = true })

local function store_hook()
    if package.loaded["neo-tree"] then vim.cmd("Neotree action=close") end

    -- Close all directory buffers
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buftype == "dirvish" then vim.api.nvim_buf_delete(buf, { force = true }) end
    end

    -- Close SymbolsOutline if open
    if package.loaded["symbols-outline"] then
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].buftype == "Outline" then
                -- vim.api.nvim_buf_delete(buf, { force = true })
                vim.cmd("SymbolsOutlineClose")
            end
        end
    end

    if package.loaded["neotest"] then
        require("neotest").output_panel.close()
        require("neotest").summary.close()
    end
    if package.loaded["edgy"] then require("edgy").close() end
    if package.loaded["dapui"] then require("dapui").close() end
    if package.loaded["diffview"] then vim.cmd([[DiffviewClose]]) end

    -- Close Neogit
    if package.loaded["neogit"] then
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "NeogitStatus" then vim.api.nvim_win_close(win, true) end
        end
    end
    -- Close ToggleTerm
    if package.loaded["toggleterm"] then
        for _, term in pairs(require("toggleterm.terminal").get_all(true)) do
            term:close()
        end
    end
end

-- Delete the current session
local function delete_session()
    local Session = require("projections.session")
    local info = Session.info(vim.fn.getcwd())
    if vim.fn.delete(info.path.path) == 0 then
        -- Delete the AutoCommand group to prevent the same Session file from being recreated
        vim.api.nvim_del_augroup_by_id(augroup)
        vim.notify("Successfully deleted session!\nSession file: " .. info.path.path, vim.log.levels.INFO)
    else
        vim.notify("Could not delete session\nSession file: " .. info.path.path, vim.log.levels.ERROR)
    end
end

return {
    {
        "GnikDroy/projections.nvim",
        lazy = false,
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
            -- restore_hooks = { post = restore_hook },
        },
        config = function(_, opts)
            -- Setup projections.nvim plugin
            require("projections").setup(opts)

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
    },
    {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = function(_, opts)
            opts.commands = opts.commands or {}
            table.insert(opts.commands, {
                ":SwitchProject",
                function()
                    -- Bind telescope keybinding for browsing projects
                    require("telescope").load_extension("projections")
                    vim.cmd([[Telescope projections]])
                end,
                description = "Switch Project",
            })
            table.insert(opts.commands, {
                ":DeleteSession",
                delete_session,
                description = "Delete Session",
            })
            table.insert(opts.commands, {
                ":AddWorkspace",
                function() require("projections.workspace").add(vim.loop.cwd()) end,
                description = "Add the pwd as Workspace",
            })
            table.insert(opts.commands, {
                ":StoreSession",
                function() require("projections.session").store(vim.loop.cwd()) end,
                description = "Store Session",
            })
            table.insert(opts.commands, {
                ":RestoreSession",
                function() require("projections.session").restore(vim.loop.cwd()) end,
                description = "Restore Session",
            })
        end,
    },
}
