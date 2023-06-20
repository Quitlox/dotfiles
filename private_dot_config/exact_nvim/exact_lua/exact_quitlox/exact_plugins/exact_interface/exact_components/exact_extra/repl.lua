return {
    {
        "folke/which-key.nvim",
        optional = true,
        opts = {
            defaults = {
                ["<localleader>r"] = { name = "REPL" },
                ["<localleader>rl"] = { name = "Log" },
                ["<localleader>re"] = { name = "Eval" },
                ["<localleader>rec"] = { name = "Eval and Comment" },
                ["<localleader>rg"] = { name = "Go" },
                ["<localleader>rc"] = { name = "Client" },
            },
        },
    },
    {
        "Olical/conjure",
        version = "",
        cmd = { "ConjureEval", "ConjureSchool", "ConjureConnect", "ConjureClientState" },
        keys = {
            { "<localleader>rlv",  desc = "Log Split" },
            { "<localleader>rlb",  desc = "Log Vertical split" },
            { "<localleader>rlt",  desc = "Log Tab" },
            { "<localleader>rlb",  desc = "Log Buffer" },
            { "<localleader>rlg",  desc = "Log toggle" },
            { "<localleader>rlr",  desc = "Log Reset soft" },
            { "<localleader>rlR",  desc = "Log Reset hard" },
            { "<localleader>rll",  desc = "Log jump Latest" },
            { "<localleader>rlq",  desc = "Log close visible" },
            { "<localleader>rec",  desc = "Eval and Comment" },
            { "<localleader>recr", desc = "Eval Root and Comment" },
            { "<localleader>recw", desc = "Eval Word and Comment" },
            { "<localleader>rew",  desc = "Eval Word" },
            { "<localleader>re!",  desc = "Eval and replace" },
            { "<localleader>rem",  desc = "Eval Mark" },
            { "<localleader>ref",  desc = "Eval File from disk" },
            { "<localleader>reb",  desc = "Eval buffer" },
            { "<localleader>rgd",  desc = "Go Definition" },

            { "<localleader>rcs",  desc = "Client Start" },
            { "<localleader>rcS",  desc = "Client Stop" },
            { "<localleader>rei",  desc = "Eval Interrupt" },
            { "<localleader>rE",   desc = "Eval visual",          mode = { "v" } },
        },
        lazy = false,
        dependencies = {
            {
                "PaterJason/cmp-conjure",
                config = function()
                    local cmp = require("cmp")
                    local config = cmp.get_config()
                    table.insert(config.sources, {
                        name = "buffer",
                        option = {
                            sources = {
                                { name = "conjure" },
                            },
                        },
                    })
                    cmp.setup(config)
                end,
            },
        },
        init = function()
            vim.g["conjure#mapping#prefix"] = "<localleader>r"
            vim.g["conjure#mapping#log_split"] = "lv"
            vim.g["conjure#mapping#log_vsplit"] = "lb"

            vim.g["conjure#client_on_load"] = false
        end,
    },
}
