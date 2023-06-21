return {
    {
        "jackMort/ChatGPT.nvim",
        cmd = { "ChatGPT", "ChatGPTRun", "ChatGPTActAs", "ChatGPTEditWithInstructions" },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        name = "chatgpt",
        opts = {
            popup_input = {
                submit = "<C-s>",
            },
            chat = {
                keymaps = {
                    close = "q",
                },
            },
        },
    },
    {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = function(_, opts)
            opts.commands = opts.commands or {}
            table.insert(opts.commands, {
                ":ChatGPT",
                description = "ChatGPT: Chat",
            })
            table.insert(opts.commands, {
                ":ChatGPTRun",
                description = "ChatGPT: Run",
            })
            table.insert(opts.commands, {
                ":ChatGPTActAs",
                description = "ChatGPT: Act as",
            })
            table.insert(opts.commands, {
                ":ChatGPTEditWithInstructions",
                description = "ChatGPT: Edit with instructions",
            })
            table.insert(opts.commands, {
                ":ChatGPTGrammarCorrection",
                ":ChatGPTRun grammar_correction",
                description = "ChatGPT: grammar_correction",
            })
            table.insert(opts.commands, {
                ":ChatGPTTranslate",
                ":ChatGPTRun translate",
                description = "ChatGPT: translate",
            })
            table.insert(opts.commands, {
                ":ChatGPTKeywords",
                ":ChatGPTRun keywords",
                description = "ChatGPT: keywords",
            })
            table.insert(opts.commands, {
                ":ChatGPTDocstring",
                ":ChatGPTRun docstring",
                description = "ChatGPT: docstring",
            })
            table.insert(opts.commands, {
                ":ChatGPTAddTests",
                ":ChatGPTRun add_tests",
                description = "ChatGPT: add_tests",
            })
            table.insert(opts.commands, {
                ":ChatGPTOptimizeCode",
                ":ChatGPTRun optimize_code",
                description = "ChatGPT: optimize_code",
            })
            table.insert(opts.commands, {
                ":ChatGPTSummarize",
                ":ChatGPTRun summarize",
                description = "ChatGPT: summarize",
            })
            table.insert(opts.commands, {
                ":ChatGPTFixBugs",
                ":ChatGPTRun fix_bugs",
                description = "ChatGPT: fix_bugs",
            })
            table.insert(opts.commands, {
                ":ChatGPTExplainCode",
                ":ChatGPTRun explain_code",
                description = "ChatGPT: explain_code",
            })
            table.insert(opts.commands, {
                ":ChatGPTRoxygenEdit",
                ":ChatGPTRun roxygen_edit",
                description = "ChatGPT: roxygen_edit",
            })
            table.insert(opts.commands, {
                ":ChatGPTCodeReadabilityAnalysis",
                ":ChatGPTRun code_readability_analysis",
                description = "ChatGPT: code_readability_analysis",
            })
        end,
    },
}
