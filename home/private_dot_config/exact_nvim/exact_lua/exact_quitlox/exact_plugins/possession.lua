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
        -- cwd = function() return not require("possession.session").exists(require("possession.paths").cwd_session_name()) end,
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
    },
})

require("telescope").load_extension("possession")

require("legendary").commands({
    { "PossessionSave", description = "Save current session" },
    { "PossessionSaveCwd", description = "Save session in current working directory" },
    { "PossessionLoadCwd", description = "Load session from current working directory" },
    { "PossessionClose", description = "Close current session" },
    { "PossessionList", description = "List available sessions" },
})

vim.keymap.set("n", "<leader>op", "<cmd>Telescope possession<cr>", { noremap = true, silent = true, desc = "Open Sessions" })
