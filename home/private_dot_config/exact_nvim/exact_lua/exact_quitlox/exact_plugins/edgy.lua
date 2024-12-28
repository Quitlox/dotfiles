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

local function filter_not_relative()
    return function(_buf, win)
        return vim.api.nvim_win_get_config(win).relative == ""
    end
end

local function filter_bt(type)
    return function(buf)
        return vim.bo[buf].buftype == type
    end
end

local function filter_terminal_wins(pos)
    return function(_buf, win)
        return vim.w[win].snacks_win and vim.w[win].snacks_win.position == pos and vim.w[win].snacks_win.relative == "editor" and not vim.w[win].trouble_preview
    end
end

--+- Keymaps ------------------------------------------------+
-- vim.keymap.set("n", "<leader>os", "<cmd>lua require('edgy').toggle()<cr>", { desc = "Open Sidebar" })

--+- Setup --------------------------------------------------+
require("edgy").setup({
    -- stylua: ignore start
    left = {
        { title = "Neotree",         ft = "neo-tree",          wo = { winbar = "    File Explorer" },                            filter = filter_nt_source_neq("document_symbols") },
        { title = "DAP Scopes",      ft = "dapui_scopes",      wo = { winbar = "  󰒉  Scopes" },                                   size = { height = 0.125 } },
        { title = "DAP Breakpoints", ft = "dapui_breakpoints", wo = { winbar = "    Breakpoints" },                              size = { height = 0.125 } },
        { title = "DAP Call Stack",  ft = "dapui_stacks",      wo = { winbar = "    Call Stack" },                               size = { height = 0.125 } },
        { title = "DAP Watches",     ft = "dapui_watches",     wo = { winbar = "    Watches" },                                  size = { height = 0.125 } },
    },
    right = {
        { title = "Neotest",         ft = "neotest-summary",   wo = { winbar = "    Tests" } },
        { title = "Outline",         ft = "neo-tree",          wo = { winbar = "  󰙅  Outline" },                                  filter = filter_nt_source_eq("document_symbols") },
        { title = "Terminal",        ft = "snacks_terminal",   wo = { winbar = "  󰜎  Task: %{b:term_title}" },                    size = { width = 80 },   filter = filter_terminal_wins("right") },
    },
    bottom = {
        { title = "Overseer",        ft = "OverseerList",      wo = { winbar = "    Overseer" },                                 size = { height = 20 } },
        { title = "Neogit",          ft = "NeogitStatus",      wo = { winbar = "    Neogit" },                                   size = { height = 20 } },
        { title = "Gitlab",          ft = "gitlab",            wo = { winbar = "    Gitlab" } },

        { title = "Trouble",         ft = "trouble",           wo = { winbar = "  󰍉  Trouble" },                                  size = { height = 15 } },
        { title = "QuickFix",        ft = "qf",                wo = { winbar = "  󰍉  QuickFix" } },
        { title = "Help",            ft = "help",              wo = { winbar = "    Help" },                                     size = { height = 20 },  filter = filter_bt("help") },
        { title = "Spectre",         ft = "spectre_panel",     wo = { winbar = "  󰛔  Find & Replace" },                           size = { height = 0.4 } },

        { title = "DAP REPL",        ft = "dap-repl",          wo = { winbar = "  󰜎  Dap REPL" } },
        { title = "DAP Console",     ft = "dapui_console",     wo = { winbar = "  󰆍  DAP Console" } },

        { title = "Terminal",        ft = "snacks_terminal",   wo = { winbar = "    %{b:snacks_terminal.id}: %{b:term_title}" }, size = { height = 0.4 }, filter = filter_terminal_wins("bottom") },
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

    -- wo = {
    --     winbar = true,
    --     winhighlight = "WinBar:EdgyWinBar,Normal:EdgyNormal",
    --     -- foldcolumn = "1",
    --     -- foldenable = false,
    -- },

    icons = {
        closed = "  ",
        open = "  ",
    },
})
