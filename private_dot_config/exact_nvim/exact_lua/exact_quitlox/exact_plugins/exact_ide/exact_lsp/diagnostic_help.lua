return {
    "piersolenski/wtf.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    keys = {
        { "gs", mode = { "n", "x" }, function() require("wtf").ai() end, desc = "Debug diagnostic with AI" },
        { "gS", mode = { "n" }, function() require("wtf").search() end, desc = "Search diagnostic with Google" },
    },
}
