-- +---------------------------------------------------------+
-- | jedrzejboczar/possesions.nvim: Session Management       |
-- +---------------------------------------------------------+

vim.opt.sessionoptions = vim.opt.sessionoptions:remove("blank")
vim.opt.sessionoptions = vim.opt.sessionoptions:remove("folds")
vim.opt.sessionoptions = vim.opt.sessionoptions:append("localoptions")

-- On startup, check whether VIRTUAL_ENV is set and activate it.
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if os.getenv("VIRTUAL_ENV") then
            vim.notify("Found VIRTUAL_ENV set in terminal, activating it.", "info", { title = "Possession" })
            require("quitlox.util.python").activate_venv(os.getenv("VIRTUAL_ENV"), nil, nil)
            return
        end
    end,
})

-- Toggle
vim.g.toggle_session_auto_save = true
Snacks.toggle
    .new({
        name = "Session Auto Save",
        set = function(state)
            vim.g.toggle_session_auto_save = state
        end,
        get = function()
            return vim.g.toggle_session_auto_save
        end,
    })
    :map("<leader>Ts")

-- When neo-tree is loaded, restore the state of the tree (if any)
require("quitlox.archive.possession.plugins.neo-tree").setup_events_for_neotree()

require("possession").setup({
    silent = true,
    load_silent = false,
    logfile = false,
    prompt_no_cr = true,
    autosave = {
        cwd = function()
            -- never save a session in the home directory, as this is the default path where neovim starts
            if require("possession.paths").cwd_session_name() == "~" then
                return false
            end

            -- prevent overwriting sessions (from README)
            if require("possession.session").exists(require("possession.paths").cwd_session_name()) then
                return false
            end

            return vim.g.toggle_session_auto_save
        end,
        current = function()
            return vim.g.toggle_session_auto_save
        end,
        on_load = true,
        on_quit = true,
    },
    autoload = "auto_cwd",
    hooks = {
        before_save = function(name)
            local user_data = {}

            user_data.venv = require("quitlox.archive.possession.plugins.venv-selector").before_save(nil, name)
            user_data.overseer = require("quitlox.archive.possession.plugins.overseer").before_save(nil, name)
            user_data.neotree = require("quitlox.archive.possession.plugins.neo-tree").before_save(nil, name)

            return user_data
        end,
        after_save = function(name, user_data, aborted) end,
        before_load = function(name, user_data)
            require("quitlox.archive.possession.plugins.venv-selector").before_load()
            require("quitlox.archive.possession.plugins.overseer").before_load()

            return user_data
        end,
        after_load = function(name, user_data)
            if user_data then
                require("quitlox.archive.possession.plugins.venv-selector").after_load(nil, name, user_data.venv)
                require("quitlox.archive.possession.plugins.overseer").after_load(nil, name, user_data.overseer)
                require("quitlox.archive.possession.plugins.neo-tree").after_load(nil, name, user_data.neotree)
            end

            -- Exit to normal mode, ensuring we're not in insert mode
            vim.cmd("stopinsert")
        end,
    },
    plugins = {
        nvim_tree = false,
        neo_tree = true,
        symbols_outline = false,
        outline = false,
        tabby = false,
        dap = true,
        dapui = true,
        neotest = true,
        delete_buffers = false,
        stop_lsp_clients = false,
    },
})

local function delete_and_exit()
    vim.g.toggle_session_auto_save = false

    local cwd_session_name = require("possession.paths").cwd_session_name()
    if not require("possession.session").exists(cwd_session_name) then
        return vim.notify("No session to delete for " .. cwd_session_name, "warning")
    end

    require("possession").delete(cwd_session_name)

    vim.schedule(function()
        vim.cmd("qa")
    end)
end

-- Commands
vim.api.nvim_create_user_command("DeleteSessionAndExit", delete_and_exit, { desc = "Possession: Delete Session and Exit" })
