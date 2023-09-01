return {
    {
        "jackMort/ChatGPT.nvim",
        commit = "24bcca7",
        cmd = { "ChatGPT", "ChatGPTRun", "ChatGPTActAs", "ChatGPTEditWithInstructions" },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        name = "chatgpt",
        keys = {
            { "<leader>mc", "<cmd>ChatGPT<cr>", desc = "ChatGPT" },
        },
        opts = {
            popup_input = {
                submit = "<C-s>",
            },
            chat = {
                keymaps = {
                    select_session = { "<cr>", "i" },
                    -- close = "q",
                },
            },
            openai_params = {
                model = "gpt-3.5-turbo",
            },
        },
    },
    {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = function(_, opts)
            opts.commands = opts.commands or {}

            vim.list_extend(opts.commands, {
                { "ChatGPT",                     description = "ChatGPT: Chat" },
                { "ChatGPTRun",                  description = "ChatGPT: Run" },
                { "ChatGPTActAs",                description = "ChatGPT: Act as" },
                { "ChatGPTEditWithInstructions", description = "ChatGPT: Edit with instructions" },
                {
                    "ChatGPTGrammarCorrection",
                    "ChatGPTRun grammar_correction",
                    description = "ChatGPT: grammar_correction",
                },
                {
                    "ChatGPTTranslate",
                    "ChatGPTRun translate",
                    description = "ChatGPT: translate",
                },
                {
                    "ChatGPTKeywords",
                    "ChatGPTRun keywords",
                    description = "ChatGPT: keywords",
                },
                {
                    "ChatGPTDocstring",
                    "ChatGPTRun docstring",
                    description = "ChatGPT: docstring",
                },
                {
                    "ChatGPTAddTests",
                    "ChatGPTRun add_tests",
                    description = "ChatGPT: add_tests",
                },
                {
                    "ChatGPTOptimizeCode",
                    "ChatGPTRun optimize_code",
                    description = "ChatGPT: optimize_code",
                },
                {
                    "ChatGPTSummarize",
                    "ChatGPTRun summarize",
                    description = "ChatGPT: summarize",
                },
                {
                    "ChatGPTFixBugs",
                    "ChatGPTRun fix_bugs",
                    description = "ChatGPT: fix_bugs",
                },
                {
                    "ChatGPTExplainCode",
                    "ChatGPTRun explain_code",
                    description = "ChatGPT: explain_code",
                },
                {
                    "ChatGPTRoxygenEdit",
                    "ChatGPTRun roxygen_edit",
                    description = "ChatGPT: roxygen_edit",
                },
                {
                    "ChatGPTCodeReadabilityAnalysis",
                    "ChatGPTRun code_readability_analysis",
                    description = "ChatGPT: code_readability_analysis",
                },
            })
        end,
    },
}
