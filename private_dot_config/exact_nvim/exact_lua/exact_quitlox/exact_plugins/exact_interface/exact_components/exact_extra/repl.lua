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
        lazy = true,
        cmd = {
            "ConjureEval",
            "ConjureSchool",
            "ConjureConnect",
            "ConjureClientState",
            --
            "ConjureLogSplit",
            "ConjureLogVSplit",
            "ConjureLogTab",
            "ConjureLogBuf",
            "ConjureLogToggle",
            "ConjureLogResetSoft",
            "ConjureLogResetHard",
            "ConjureLogJumpToLatest",
            "ConjureLogCloseVisible",
            --
            "ConjureEvalCurrentForm",
            "ConjureEvalCommentCurrentForm",
            "ConjureEvalRootForm",
            "ConjureEvalCommentRootForm",
            "ConjureEvalWord",
            "ConjureEvalCommentWord",
            "ConjureEvalReplaceForm",
            "ConjureEvalMarkedForm",
            "ConjureEvalCommentForm",
            "ConjureEvalFile",
            "ConjureEvalBuf",
            "ConjureEvalMotion",
            "ConjureEvalVisual",
        },
        keys = {
            { "<localleader>rlv",  desc = "Log Split" },
            { "<localleader>rlb",  desc = "Log Vertical split" },
            { "<localleader>rlt",  desc = "Log Tab" },
            { "<localleader>rlb",  desc = "Log Buffer" },
            { "<localleader>rlg",  desc = "Log toggle" },
            { "<localleader>rlr",  desc = "Log Reset soft" },
            { "<localleader>rlR",  desc = "Log Reset hard" },
            { "<localleader>rll",  desc = "Log jumpConjure Latest" },
            { "<localleader>rlq",  desc = "Log close visible" },
            { "<localleader>ree",  desc = "Eval" },
            { "<localleader>rece", desc = "Eval and Comment" },
            { "<localleader>rer",  desc = "Eval Root" },
            { "<localleader>recr", desc = "Eval Root and Comment" },
            { "<localleader>rew",  desc = "Eval Word" },
            { "<localleader>recw", desc = "Eval Word and Comment" },
            { "<localleader>re!",  desc = "Eval and replace" },
            { "<localleader>rem",  desc = "Eval Mark" },
            { "<localleader>rec",  desc = "Eval Form and Comment" },
            { "<localleader>ref",  desc = "Eval File from disk" },
            { "<localleader>reb",  desc = "Eval buffer" },
            { "<localleader>rE",   desc = "Eval Motion",           mode = { "n" } },
            { "<localleader>rE",   desc = "Eval Motion",           mode = { "v" } },
            --
            { "<localleader>rgd",  desc = "Go Definition" },
            { "<localleader>rK",   desc = "Look up doc" },
            --
            { "<localleader>rcs",  desc = "Client Start" },
            { "<localleader>rcS",  desc = "Client Stop" },
            { "<localleader>rei",  desc = "Eval Interrupt" },
        },
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
        config = function(_, opts)
            require("conjure.main").main()
            require("conjure.mapping")["on-filetype"]()
        end,
        init = function()
            vim.g["conjure#mapping#prefix"] = "<localleader>r"
            vim.g["conjure#mapping#log_split"] = "lv"
            vim.g["conjure#mapping#log_vsplit"] = "lb"
            vim.g["conjure#mapping#doc_word"] = "<localleader>rK"

            vim.g["conjure#client_on_load"] = false
        end,
    },
}
