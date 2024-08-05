-- +---------------------------------------------------------+
-- | folke/edgy.nvim: Sidebar                                |
-- +---------------------------------------------------------+

local function filter_nt_source_eq(source)
    return function(buf) return vim.b[buf].neo_tree_source == source end
end

local function filter_nt_source_neq(source)
    return function(buf) return vim.b[buf].neo_tree_source ~= source end
end

local function filter_not_relative()
    return function(_buf, win) return vim.api.nvim_win_get_config(win).relative == "" end
end

local function filter_bt(type)
    return function(buf) return vim.bo[buf].buftype == type end
end

--+- Keymaps ------------------------------------------------+
-- vim.keymap.set("n", "<leader>os", "<cmd>lua require('edgy').toggle()<cr>", { desc = "Open Sidebar" })

--+- Setup --------------------------------------------------+
require("edgy").setup({
    left = {
        { ft = "neo-tree", filter = filter_nt_source_neq("document_symbols"), wo = { winbar = "    File Explorer" } },
        { ft = "dapui_scopes", size = { height = 0.125 }, wo = { winbar = " 󰒉  Scopes" } },
        { ft = "dapui_breakpoints", size = { height = 0.125 }, wo = { winbar = "    Breakpoints" } },
        { ft = "dapui_stacks", size = { height = 0.125 }, wo = { winbar = "    Call Stack" } },
        { ft = "dapui_watches", size = { height = 0.125 }, wo = { winbar = "   Watches" } },
    },
    right = {
        { ft = "neotest-summary" },
        { title = "Outline", ft = "neo-tree", filter = filter_nt_source_eq("document_symbols"), wo = { winbar = "  󰙅  Outline" } },
    },
    bottom = {
        { ft = "toggleterm", size = { height = 0.4 }, filter = filter_not_relative(), wo = { winbar = "  󰆍  Terminal" } },
        { title = "Overseer", size = { height = 20 }, ft = "OverseerList", wo = { winbar = "    Overseer" } },
        { ft = "NeogitStatus", size = { height = 20 }, wo = { winbar = "  󰊢  Neogit" } },
        { ft = "gitlab", wo = { winbar = "  󰊢  Gitlab" } },

        { ft = "trouble", size = { height = 15 }, wo = { winbar = "󰍉  Trouble" } },
        { ft = "qf", title = "QuickFix", wo = { winbar = "  󰍉  QuickFix" } },
        { ft = "help", size = { height = 20 }, filter = filter_bt("help"), wo = { winbar = "    Help" } },
        { ft = "spectre_panel", size = { height = 0.4 } },

        { ft = "dap-repl", wo = { winbar = "  󰜎 Dap REPL" } },
        { ft = "dapui_console", wo = { winbar = "  󰆍  DAP Console" } },
    },

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
    keys = {
        -- FIXME: For some reason, disabling this fixes the wait after q
        ["q"] = false,
    },

    wo = {
        winbar = true,
        winhighlight = "WinBar:EdgyWinBar,Normal:EdgyNormal",
        -- foldcolumn = "1",
        -- foldenable = false,
    },

    icons = {
        closed = "  ",
        open = "  ",
    },

    fix_win_height = vim.fn.has("nvim-0.10.0") == 0,
})
