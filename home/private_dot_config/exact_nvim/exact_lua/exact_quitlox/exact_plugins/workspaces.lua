-- +---------------------------------------------------------+
-- | natecraddock/workspaces.nvim: Workspace Selector        |
-- +---------------------------------------------------------+

vim.keymap.set("n", "<leader>op", "<cmd>WorkspacesOpen<cr>", { noremap = true, silent = true, desc = "Open Projects" })

--- Convert the given workspace.nvim path to a possession.nvim path
local function to_possesion_path(path)
    path = path:gsub("^" .. os.getenv("HOME"), "~")
    path = path:gsub("/$", "")
    return path
end

require("workspaces").setup({
    -- cd_type = "tab", -- FIXME: Not compatible with possession.nvim
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
            if not curr_path then
                return
            end

            local autosave_info = possession_session.autosave_info()
            if not possession_config.autosave.on_load or not autosave_info then
                return
            end

            local next_session = possession_paths.session(to_possesion_path(path))
            if next_session:exists() then
                local session_data = vim.json.decode(next_session:read())
                if session_data.name == autosave_info.name then
                    return
                end
            end

            possession_session.autosave()
            vim.wait(100, function() end) -- Stupid hack to wait for Neo-tree to close and open before/after saving
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
