return {
    "simrat39/symbols-outline.nvim",
    config = true,
    opts = {
        symbol_blacklist = { "Variable", "TypeParameter", "NULL", "Field" },
        symbols = {
            File = { icon = "", hl = "@text.uri" },
            Module = { icon = "", hl = "@namespace" },
            Namespace = { icon = "", hl = "@namespace" },
            Package = { icon = "", hl = "@namespace" },
            Class = { icon = "ﴯ", hl = "@type" },
            Method = { icon = "", hl = "@method" },
            Property = { icon = "ﰠ", hl = "@method" },
            -- Field = { icon = "ﰠ", hl = "@field" },
            Constructor = { icon = "", hl = "@constructor" },
            Enum = { icon = "", hl = "@type" },
            Interface = { icon = "", hl = "@type" },
            Function = { icon = "", hl = "@function" },
            Variable = { icon = "", hl = "@constant" },
            Constant = { icon = "", hl = "@constant" },
            String = { icon = "𝓐", hl = "@string" },
            Number = { icon = "#", hl = "@number" },
            Boolean = { icon = "⊨", hl = "@boolean" },
            Array = { icon = "", hl = "@constant" },
            Object = { icon = "⦿", hl = "@type" },
            Key = { icon = "🔐", hl = "@type" },
            -- Null = { icon = "NULL", hl = "@type" },
            EnumMember = { icon = "", hl = "@field" },
            Struct = { icon = "פּ", hl = "@type" },
            Event = { icon = "", hl = "@type" },
            Operator = { icon = "", hl = "@operator" },
            -- TypeParameter = { icon = "𝙏", hl = "@parameter" },
            Component = { icon = "", hl = "@function" },
            Fragment = { icon = "", hl = "@constant" },
        },
    },
    init = function()
        require("which-key").register({
            ["o"] = {
                ["o"] = { "<cmd>SymbolsOutline<cr>", "Open Outline" },
            },
            ["l"] = {
                ["s"] = { "<cmd>SymbolsOutlineOpen<cr>", "Locate Symbol" },
            },
        }, {prefix = "<leader>"})
    end,
}
