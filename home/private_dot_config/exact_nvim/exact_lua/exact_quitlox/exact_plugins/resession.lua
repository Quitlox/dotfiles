-- +---------------------------------------------------------+
-- | stevearc/resession.nvim: Session Management             |
-- +---------------------------------------------------------+

--+- Setup --------------------------------------------------+
local resession = require("resession")
resession.setup({
    -- Config: Only save buffers in current tab-local directory
    tab_buf_filter = function(tabpage, bufnr)
        local dir = vim.fn.getcwd(-1, vim.api.nvim_tabpage_get_number(tabpage))
        -- ensure dir has trailing /
        dir = dir:sub(-1) ~= "/" and dir .. "/" or dir
        return vim.startswith(vim.api.nvim_buf_get_name(bufnr), dir)
    end,
    -- Config: Extensions
    extensions = {
        venv_selector = {
            enable_in_tab = true,
        },
        neo_tree = {
            enable_in_tab = true,
        },
        neotest = {
            enable_in_tab = true,
        },
        overseer = {},
    },
})

--+- Keymaps ------------------------------------------------+
vim.keymap.set("n", "<leader>os", resession.load)

--+- Config: Auto-Save on Exit ------------------------------+
vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        -- Always save a special session named "last"
        resession.save("last")
    end,
})

--+- Config: Session per Git Branch -------------------------+
local function get_session_name()
    local name = vim.fn.getcwd()
    local branch = vim.trim(vim.fn.system("git branch --show-current"))
    if vim.v.shell_error == 0 then
        return name .. ":" .. branch
    else
        return name
    end
end

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- Only load the session if nvim was started with no args
        if vim.fn.argc(-1) == 0 then
            resession.load(get_session_name(), { dir = "dirsession", silence_errors = true })
        end
    end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        resession.save_tab(get_session_name(), { dir = "dirsession", notify = true })
    end,
})

--+- Integration: Venv-selector -----------------------------+
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
