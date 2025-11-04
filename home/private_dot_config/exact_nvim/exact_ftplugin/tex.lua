-- +- Integration: Luasnip -----------------------------------+
require("luasnip").setup({
    enable_autosnippets = true,
})

-- +- Integration: Which-key.nvim ----------------------------+
require("which-key").add({
    { "<localleader>", group = "LaTeX", buffer = 0 },
    { "<localleader>a", desc = "Context menu", buffer = 0 },
    { "<localleader>C", desc = "Clean full", buffer = 0 },
    { "<localleader>c", desc = "Clean", buffer = 0 },
    { "<localleader>e", desc = "Errors", buffer = 0 },
    { "<localleader>g", desc = "Status", buffer = 0 },
    { "<localleader>G", desc = "Status all", buffer = 0 },
    { "<localleader>I", desc = "Info full", buffer = 0 },
    { "<localleader>i", desc = "Info", buffer = 0 },
    { "<localleader>K", desc = "Kill all", buffer = 0 },
    { "<localleader>k", desc = "Kill", buffer = 0 },
    { "<localleader>l", desc = "Compile", buffer = 0 },
    { "<localleader>L", desc = "Compile selected", buffer = 0 },
    { "<localleader>m", desc = "Mappings list", buffer = 0 },
    { "<localleader>o", desc = "Compilation Output", buffer = 0 },
    { "<localleader>q", desc = "Log", buffer = 0 },
    { "<localleader>s", desc = "Toggle main", buffer = 0 },
    { "<localleader>t", desc = "ToC open", buffer = 0 },
    { "<localleader>T", desc = "ToC toggle", buffer = 0 },
    { "<localleader>v", desc = "View", buffer = 0 },
    { "<localleader>X", desc = "Reload state", buffer = 0 },
    { "<localleader>x", desc = "Reload", buffer = 0 },
})
