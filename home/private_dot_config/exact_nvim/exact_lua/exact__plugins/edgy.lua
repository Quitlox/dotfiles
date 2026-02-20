-- +---------------------------------------------------------+
-- | folke/edgy.nvim: Sidebar                                |
-- +---------------------------------------------------------+

local function filter_nt_source_eq(source)
    return function(buf)
        return vim.b[buf].neo_tree_source == source
    end
end

local function filter_nt_source_neq(source)
    return function(buf)
        return vim.b[buf].neo_tree_source ~= source
    end
end

local function filter_bt(type)
    return function(buf)
        return vim.bo[buf].buftype == type
    end
end

local function filter_has_bufopt(opt)
    return function(buf)
        local success, result = pcall(vim.api.nvim_buf_get_var, buf, opt)
        return success and result ~= nil
    end
end

local function filter_terminal_wins(pos)
    return function(_buf, win)
        return vim.w[win].snacks_win and vim.w[win].snacks_win.position == pos and vim.w[win].snacks_win.relative == "editor" and not vim.w[win].trouble_preview
    end
end

--+- Setup --------------------------------------------------+
-- NOTE: The titles are only shown when the winbar of lualine has been disabled.
require("edgy").setup({
    -- stylua: ignore start
    left = {
        { title = "Neo-Tree",        ft = "neo-tree",          wo = { winbar = "    File Explorer" },                            filter = filter_nt_source_neq("document_symbols") },
        { title = "DAP Scopes",      ft = "dapui_scopes",      wo = { winbar = "  󰒉  Scopes" },                                   size = { height = 0.125 } },
        { title = "DAP Breakpoints", ft = "dapui_breakpoints", wo = { winbar = "    Breakpoints" },                              size = { height = 0.125 } },
        { title = "DAP Call Stack",  ft = "dapui_stacks",      wo = { winbar = "    Call Stack" },                               size = { height = 0.125 } },
        { title = "DAP Watches",     ft = "dapui_watches",     wo = { winbar = "    Watches" },                                  size = { height = 0.125 } },
    },
    right = {
        { title = "Neotest",         ft = "neotest-summary",   wo = { winbar = "    Tests" } },
        { title = "Outline",         ft = "neo-tree",          wo = { winbar = "    Outline" },                                  filter = filter_nt_source_eq("document_symbols") },
        { title = "Outline",         ft = "aerial",            wo = { winbar = "    Outline", signcolumn = "yes:1"},             size = { } },
        { title = "Find & Replace",  ft = "grug-far",          wo = { winbar = "    Find & Replace" },                           size = { width = 70 } },
        { title = "Overseer Jobs",   ft = "snacks_terminal",   wo = { winbar = "  󰜎  Task: %{b:term_title}" },                    size = { width = 80 },   filter = filter_terminal_wins("right") },
        { title = "Copilot Chat",    ft = "copilot-chat",      wo = { winbar = "    Copilot Chat" },                             size = { width = 70 } },
        { title = "CodeCompanion",   ft = "codecompanion",     wo = { winbar = "    CodeCompanion" },                            size = { width = 70 } },
    },
    bottom = {
        { title = "Overseer",        ft = "OverseerList",      wo = { winbar = "    Overseer (Task List)" },                     size = { width = 40 } },
        { title = "Overseer Output", ft = "OverseerOutput",    wo = { winbar = "    Overseer (Output)" },                        size = { height = 15 } },

        { title = "Neogit",          ft = "NeogitStatus",      wo = { winbar = "    Neogit" },                                   size = { height = 20 } },
        { title = "Gitlab",          ft = "gitlab",            wo = { winbar = "  󰮠  Gitlab" } },

        { title = "Trouble",         ft = "trouble",           wo = { winbar = "    Trouble" },                                  size = { height = 15 } },
        { title = "QuickFix",        ft = "qf",                wo = { winbar = "    QuickFix" } },
        { title = "Help",            ft = "help",              wo = { winbar = "    Help" },                                     size = { height = 20 },  filter = filter_bt("help") },
        { title = "Find & Replace",  ft = "spectre_panel",     wo = { winbar = "    Find & Replace" },                           size = { height = 0.4 } },

        { title = "DAP REPL",        ft = "dap-repl",          wo = { winbar = "    Dap REPL" } },
        { title = "DAP Console",     ft = "dapui_console",     wo = { winbar = "    DAP Console" } },

        { title = "Terminal",        ft = "snacks_terminal",   wo = { winbar = "    %{b:snacks_terminal.id}: %{b:term_title}" }, size = { height = 0.35 }, filter = filter_terminal_wins("bottom") },
        { title = "QuickTest",       ft = "quicktest-output",  wo = { winbar = "    Tests" },                                    size = { height = 20 } },
        { title = "LSP Output",      ft = "outputpanel",       wo = { winbar = "    LSP Output" } },
    },
    -- stylua: ignore end

    animate = {
        enabled = false,
    },

    options = {
        left = { size = 40 },
        right = {
            size = 50,
            wo = {
                -- Unfortunately, this doesn't fix the highlight issue with the WinSeparator
                -- Vertical WinSeparators are rendered on the _right_ side of the window.
                -- Thus we must set the WinSeparator on the split next to the sidebar
                -- winhighlight = "WinBar:EdgyWinBar,Normal:EdgyNormal,WinSeparator:Normal",
            },
        },
        -- bottom = { size = 0.40 },
    },

    -- keys = {
    --     -- FIXME: For some reason, disabling this fixes the wait after q
    --     ["q"] = false,
    -- },

    icons = {
        closed = "  ",
        open = "  ",
    },
})
