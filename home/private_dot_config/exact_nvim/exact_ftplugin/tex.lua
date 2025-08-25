-- +- Integration: Wrapping.nvim -----------------------------+
require("wrapping").soft_wrap_mode()

-- +- Integration: Luasnip -----------------------------------+
require("luasnip").setup({
    enable_autosnippets = true,
})

-- +- Integration: Which-key.nvim ----------------------------+
require("which-key").add({
    { "<localleader>l", group = "LaTeX" },
    { "<localleader>la", desc = "Context menu" },
    { "<localleader>lC", desc = "Clean full" },
    { "<localleader>lc", desc = "Clean" },
    { "<localleader>le", desc = "Errors" },
    { "<localleader>lg", desc = "Status" },
    { "<localleader>lG", desc = "Status all" },
    { "<localleader>lI", desc = "Info full" },
    { "<localleader>li", desc = "Info" },
    { "<localleader>lK", desc = "Kill all" },
    { "<localleader>lk", desc = "Kill" },
    { "<localleader>ll", desc = "Compile" },
    { "<localleader>lL", desc = "Compile selected" },
    { "<localleader>lm", desc = "Mappings list" },
    { "<localleader>lo", desc = "Compilation Output" },
    { "<localleader>lq", desc = "Log" },
    { "<localleader>ls", desc = "Toggle main" },
    { "<localleader>lt", desc = "ToC open" },
    { "<localleader>lT", desc = "ToC toggle" },
    { "<localleader>lv", desc = "View" },
    { "<localleader>lX", desc = "Reload state" },
    { "<localleader>lx", desc = "Reload" },

    -- Override outline with toc
    { "<leader>o", group = "Outline" },
    { "<leader>oo", "<cmd>VimtexTocToggle<cr>", desc = "Open ToC" },
})
