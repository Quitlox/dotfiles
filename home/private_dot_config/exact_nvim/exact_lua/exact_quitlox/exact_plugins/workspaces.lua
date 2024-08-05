-- +---------------------------------------------------------+
-- | natecraddock/workspaces.nvim: Workspace Selector        |
-- +---------------------------------------------------------+

require("legendary").commands({
    { ":WorkspacesAdd [name] [path]", description = "Add a workspace (project)", unfinished = true },
    { ":WorkspacesAddDir [name]", description = "Add a workspace directory", unfinished = true },
    { ":WorkspacesRemove [name]", description = "Remove a workspace", unfinished = true },
    { ":WorkspacesRemoveDir [name]", description = "Remove a workspace directory", unfinished = true },
    { ":WorkspacesRename [name] [new_name]", description = "Rename a workspace", unfinished = true },
    { ":WorkspacesList", description = "List all workspaces" },
    { ":WorkspacesListDirs", description = "List all workspace directories" },
    { ":WorkspacesOpen [name]", description = "Open a workspace", unfinished = true },
    { ":WorkspacesSyncDirs", description = "Synchronize workspaces from registered directories" },
})

vim.keymap.set("n", "<leader>op", "<cmd>Telescope workspaces<cr>", { noremap = true, silent = true, desc = "Open Projects" })

--- Convert the given workspace.nvim path to a possession.nvim path
local function to_possesion_path(path)
    path = path:gsub("^" .. os.getenv("HOME"), "~")
    path = path:gsub("/$", "")
    return path
end

require("workspaces").setup({
    hooks = {
        add = {},
        remove = {},
        rename = {},
        open_pre = function(name, path, state)
            local workspaces = require("workspaces")
            local possession_paths = require("possession.paths")
            local possession_config = require("possession.config")
            local possession_session = require("possession.session")

            local curr_path = workspaces.path()
            if not curr_path then return end

            local autosave_info = possession_session.autosave_info()
            if not possession_config.autosave.on_load or not autosave_info then return end

            local next_session = possession_paths.session(to_possesion_path(path))
            if next_session:exists() then
                local session_data = vim.json.decode(next_session:read())
                if session_data.name == autosave_info.name then return end
            end

            possession_session.autosave()
        end,
        --- Automatically load the session of the given workspace if it exists.
        --- Otherwise, only close down the current session.
        open = function(name, path, state)
            path = to_possesion_path(path)

            if require("possession.paths").session(path):exists() then
                require("possession.session").load(path, { skip_autosave = true })
            else
                require("possession.session").close()
            end
        end,
    },
})

require("telescope").load_extension("workspaces")
