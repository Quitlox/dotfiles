-- +---------------------------------------------------------+
-- | stevearc/resession.nvim: Session Management             |
-- +---------------------------------------------------------+
local get_session_name = require("_config.util.session").get_session_name

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
        -- "cmdheight",
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
        neo_tree = { enable_in_tab = true },
        neotest = { enable_in_tab = true },
        overseer = { enable_in_tab = true },
        ["treesitter-context"] = { enable_in_tab = true },
        dart = { enable_in_tab = false },
    },
})

resession.add_hook("pre_load", function()
    require("_config.util.session").notify('Loading session: "' .. get_session_name() .. '"', "info")
end)

--+- Hook: Close help windows pre_save ----------------------+
local function close_help_windows(target_tabpage)
    -- Close help windows before saving so they are never persisted in a session
    local tabpages = target_tabpage and { target_tabpage } or vim.api.nvim_list_tabpages()
    for _, tabpage in ipairs(tabpages) do
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
            if vim.api.nvim_win_is_valid(win) then
                local bufnr = vim.api.nvim_win_get_buf(win)
                if vim.bo[bufnr].buftype == "help" then
                    pcall(vim.api.nvim_win_close, win, false)
                end
            end
        end
    end
end

resession.add_hook("pre_save", function(_, _, target_tabpage)
    close_help_windows(target_tabpage)
end)

--+- Keymaps ------------------------------------------------+
vim.keymap.set("n", "<leader>os", function()
    -- Only show tab-scoped sessions
    local sessions = resession.list()
    local tab_sessions = {}

    -- Filter for tab-scoped sessions only
    local files = require("resession.files")
    local resession_util = require("resession.util")

    for _, session_name in ipairs(sessions) do
        local session_filename = resession_util.get_session_file(session_name)
        local session_data = files.load_json_file(session_filename)
        if session_data and session_data.tab_scoped then
            table.insert(tab_sessions, session_name)
        end
    end

    if #tab_sessions == 0 then
        vim.notify("No tab-scoped sessions found", vim.log.levels.INFO)
        return
    end

    vim.ui.select(tab_sessions, {
        prompt = "Select tab session:",
        format_item = function(session)
            return session
        end,
    }, function(session)
        if session then
            resession.load(session, { attach = true, reset = false })
        end
    end)
end, { desc = "Open Tab Session" })

vim.keymap.set("n", "<leader>oS", function()
    -- Only show named/global sessions (non-tab-scoped)
    local sessions = resession.list()
    local global_sessions = {}

    -- Filter for global/named sessions only
    local files = require("resession.files")
    local resession_util = require("resession.util")

    for _, session_name in ipairs(sessions) do
        local session_filename = resession_util.get_session_file(session_name)
        local session_data = files.load_json_file(session_filename)
        if not session_data or not session_data.tab_scoped then
            table.insert(global_sessions, session_name)
        end
    end

    if #global_sessions == 0 then
        vim.notify("No global sessions found", vim.log.levels.INFO)
        return
    end

    vim.ui.select(global_sessions, {
        prompt = "Select global session:",
        format_item = function(session)
            return session
        end,
    }, function(session)
        if session then
            resession.load(session, { attach = true, reset = true })
        end
    end)
end, { desc = "Open Global Session" })

vim.keymap.set("n", "<leader>sn", function()
    vim.ui.input({
        prompt = "Session name: ",
        default = "",
    }, function(name)
        if name and name ~= "" then
            resession.save(name, { notify = true, attach = true })
        end
    end)
end, { desc = "Session: Save Named" })

vim.keymap.set("n", "<leader>sc", function()
    local util = require("_config.util.session")

    resession.save_tab(get_session_name(), { notify = false, attach = true })
    resession.detach()
    util.close_everything()

    -- Return to home directory
    vim.cmd("tcd " .. vim.fn.fnameescape(vim.fn.expand("~")))
    -- Open dashboard
    Snacks.dashboard.open()
end, { desc = "Session: Close" })

vim.keymap.set("n", "<leader>sd", function()
    local session_name = get_session_name()
    local util = require("_config.util.session")

    resession.detach()
    util.close_everything()
    resession.delete(session_name, { notify = true })

    -- Return to home directory
    vim.cmd("tcd " .. vim.fn.fnameescape(vim.fn.expand("~")))
    -- Open dashboard
    Snacks.dashboard.open()
end, { desc = "Session: Delete Current" })

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
            -- Don't auto-load session in home or nvim config directory - show dashboard instead
            local cwd = vim.fn.getcwd()
            local home_dir = vim.fn.expand("~")
            local nvim_config_dir = vim.fn.expand("~/.config/nvim")
            if cwd ~= home_dir and cwd ~= nvim_config_dir then
                resession.load(get_session_name(), { silence_errors = true })
            end
        end
    end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        resession.save_tab(get_session_name(), { notify = true })
    end,
})
