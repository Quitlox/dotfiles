-- +---------------------------------------------------------+
-- | jedrzejboczar/possesions.nvim: Session Management       |
-- +---------------------------------------------------------+

vim.opt.sessionoptions = vim.opt.sessionoptions:remove("blank")
vim.opt.sessionoptions = vim.opt.sessionoptions:remove("folds")
vim.opt.sessionoptions = vim.opt.sessionoptions:append("buffers")
vim.opt.sessionoptions = vim.opt.sessionoptions:append("localoptions")

-- When neo-tree is loaded, restore the state of the tree (if any)
require("possession.plugins.neo-tree").setup_events_for_neotree()

require("possession").setup({
    silent = false,
    load_silent = false,
    logfile = false,
    prompt_no_cr = true,
    autosave = {
        cwd = function()
            if require("possession.session").exists(require("possession.paths").cwd_session_name()) then
                return false
            end

            -- check that path is not ~
            local cwd = vim.fn.getcwd()
            if cwd == os.getenv("HOME") then
                return false
            end

            return true
        end,
        current = true,
        on_load = true,
        on_quit = true,
    },
    autoload = "auto_cwd",
    hooks = {
        before_save = function(name)
            local user_data = {}

            user_data.venv = require("possession.plugins.venv-selector").before_save(name)
            user_data.overseer = require("possession.plugins.overseer").before_save(name)
            user_data.neotree = require("possession.plugins.neo-tree").before_save(name)

            return user_data
        end,
        after_save = function(name, user_data, aborted) end,
        before_load = function(name, user_data)
            require("possession.plugins.venv-selector").before_load()
            require("possession.plugins.overseer").before_load()

            return user_data
        end,
        after_load = function(name, user_data)
            vim.notify("Session loaded: " .. name, "info", { title = "Possession" })
            if user_data then
                if user_data.venv then
                    require("possession.plugins.venv-selector").after_load(nil, name, user_data.venv)
                end
                if user_data.overseer then
                    require("possession.plugins.overseer").after_load(nil, name, user_data.overseer)
                end
                if user_data.neotree then
                    require("possession.plugins.neo-tree").after_load(nil, name, user_data.neotree)
                end
            end

            -- Exit to normal mode, ensuring we're not in insert mode
            vim.cmd("stopinsert")
        end,
    },
    plugins = {
        delete_hidden_buffers = {},
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
    telescope = {
        previewer = {
            enabled = false,
        },
        -- list = {
        --     default_action = "load",
        --     mappings = {
        --         save = { n = "<c-x>", i = "<c-x>" },
        --         load = { n = "<c-v>", i = "<c-v>" },
        --         delete = { n = "<c-t>", i = "<c-t>" },
        --         rename = { n = "<c-r>", i = "<c-r>" },
        --     },
        -- },
    },
})

require("telescope").load_extension("possession")

require("legendary").commands({
    { "PossessionSave", description = "Save current session" },
    { "PossessionSave [name]", description = "Save current session as", unfinished = true },
    -- { "PossessionLoad", description = "Load last session" },
    { "PossessionLoad [name]", description = "Load session", unfinished = true },
    -- { "PossessionSaveCwd", description = "Save session in current working directory" },
    -- { "PossessionLoadCwd", description = "Load last session from current working directory" },
    -- { "PossessionLoadCwd [name]", description = "Load session from current working directory", unfinished = true },
    -- { "PossessionRename", description = "Rename current session" },
    -- { "PossessionRename [name]", description = "Rename given session", unfinished = true },
    { "PossessionDelete", description = "Delete current session" },
    -- { "PossessionDelete [name]", description = "Delete given session", unfinished = true },
    { "PosessionShow", description = "Show current session info" },
    -- { "PosessionShow [name]", description = "Show given session info", unfinished = true },
    { "PossessionClose", description = "Close current session" },
    { "PossessionList", description = "List available sessions" },
    { "PossessionListCwd", description = "List available sessions for current cwd" },
    -- { "PossessionListCwd [name]", description = "List available sessions for given cwd", unfinished = true },
})

vim.keymap.set("n", "<leader>os", "<cmd>Telescope possession<cr>", { noremap = true, silent = true, desc = "Open Sessions" })
