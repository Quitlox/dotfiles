-- +---------------------------------------------------------+
-- | jedrzejboczar/possesions.nvim: Session Management       |
-- +---------------------------------------------------------+

vim.opt.sessionoptions = vim.opt.sessionoptions:remove("buffers")
vim.opt.sessionoptions = vim.opt.sessionoptions:remove("folds")

require("possession").setup({
    silent = true,
    load_silent = true,
    logfile = false,
    prompt_no_cr = true,
    autosave = {
        cwd = function()
            -- return not require("possession.session").exists(require("possession.paths").cwd_session_name())

            -- check that path is not ~
            local cwd = vim.fn.getcwd()
            if cwd == os.getenv("HOME") then return false end

            return true
        end,
        current = true,
        cwd = true,
        on_load = true,
        on_quit = true,
    },
    autoload = "auto_cwd",
    hooks = {
        before_save = function(name) return {} end,
        after_save = function(name, user_data, aborted) end,
        before_load = function(name, user_data) return user_data end,
        after_load = function(name, user_data) end,
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
        delete_buffers = true,
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
