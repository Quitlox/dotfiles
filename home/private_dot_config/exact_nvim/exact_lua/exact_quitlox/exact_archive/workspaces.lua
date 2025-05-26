-- +---------------------------------------------------------+
-- | natecraddock/workspaces.nvim: Workspace Selector        |
-- +---------------------------------------------------------+

-- vim.keymap.set("n", "<leader>op", "<cmd>WorkspacesOpen<cr>", { noremap = true, silent = true, desc = "Open Projects" })

local function substitute_home(path)
    path = path:gsub("^" .. os.getenv("HOME"), "~")
    path = path:gsub("/$", "")
    return path
end

local resession = require("resession")
local resession_util = require("resession.util")
local util = require("quitlox.util.session")

require("lua.quitlox.archive.workspaces").setup({
    cd_type = "tab",
    hooks = {
        add = {},
        remove = {},
        rename = {},
        open_pre = function(name, path, state)
            -- Save current session
            require("resession").save_tab(util.get_session_name(), { notify = false, attach = true })

            -- Stupid hack to wait for Neo-tree to close and open before/after saving
            vim.wait(100, function() end)
        end,
        --- Automatically load the session of the given workspace if it exists.
        --- Otherwise, only close down the current session.
        open = function(name, path, state)
            -- Remove trailing slash
            path = path:gsub("/$", "")

            local session_name = resession_util.get_session_file(util.get_session_name(path))
            session_name = vim.fs.basename(session_name)
            session_name = session_name:gsub("%.json$", "")
            if vim.tbl_contains(resession.list(), session_name) then
                resession.load(session_name, { attach = true, reset = true })
            else
                resession.detach()
                util.close_everything()
            end
        end,
    },
})
