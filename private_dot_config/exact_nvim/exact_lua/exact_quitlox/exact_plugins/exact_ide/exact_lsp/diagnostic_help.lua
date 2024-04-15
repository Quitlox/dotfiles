return {
    {
        "piersolenski/wtf.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        opts = {},
        keys = {
            -- stylua: ignore start
            { "gw", mode = { "n", "x" }, function() require("wtf").ai() end, desc = "Debug diagnostic with AI" },
            { "gW", mode = { "n" }, function() require("wtf").search() end, desc = "Search diagnostic with Google" },
            -- stylua: ignore end
        },
    },
    {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = function(_, opts)
            opts.commands = opts.commands or {}
            vim.list_extend(opts.commands, {
                -- stylua: ignore start
                { ":DebugDiagnosticWithAI", function() require("wtf").ai() end, description = "wtf.nvim: debug diagnostic with ai" },
                { ":SearchDiagnosticWithGoogle", function() require("wtf").search() end,description = "wtf.nvim: search diagnostic with google" },
                -- stylua: ignore end
            })
        end,
    },
}
