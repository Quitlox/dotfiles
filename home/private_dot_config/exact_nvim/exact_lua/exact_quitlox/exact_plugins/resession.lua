-- +---------------------------------------------------------+
-- | stevearc/resession.nvim: Session Management             |
-- +---------------------------------------------------------+
local get_session_name = require("quitlox.util.session").get_session_name

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
    -- Save and restore these options
    options = {
        -- Default
        "binary",
        "bufhidden",
        "buflisted",
        "cmdheight",
        "diff",
        "filetype",
        "modifiable",
        "previewwindow",
        "readonly",
        "scrollbind",
        "winfixheight",
        "winfixwidth",
        -- Custom
    },
    -- Config: Extensions
    extensions = {
        neo_tree = {
            enable_in_tab = true,
        },
        neotest = {
            enable_in_tab = true,
        },
        overseer = {
            enable_in_tab = true,
        },
        ["treesitter-context"] = {
            enable_in_tab = true,
        },
        venv_selector = {
            enable_in_tab = true,
        },
    },
})

resession.add_hook("pre_load", function()
    require("quitlox.util.session").notify('Loading session: "' .. get_session_name() .. '"', "info")
end)

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
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        -- Only load the session if nvim was started with no args
        if vim.fn.argc(-1) == 0 then
            resession.load(get_session_name(), { silence_errors = true })
        end
    end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        resession.save_tab(get_session_name(), { notify = true })
    end,
})

--+- Integration: Venv-selector -----------------------------+
-- On startup, check whether VIRTUAL_ENV is set and activate it.
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local venv = require("venv-selector").venv()
        if venv == nil and os.getenv("VIRTUAL_ENV") and os.getenv("VIRTUAL_ENV") ~= "" then
            require("quitlox.util.python").activate_venv(os.getenv("VIRTUAL_ENV"), nil, nil)
            return
        end
    end,
})
