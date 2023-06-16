return {
    "jackMort/ChatGPT.nvim",
    cmd = { "ChatGPT", "ChatGPTRun", "ChatGPTActAs", "ChatGPTEditWithInstructions" },
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        require("chatgpt").setup({
            popup_input = {
                submit = "<C-s>",
            },
            chat = {
                keymaps = {
                    close = "q",
                },
            },
        })
    end,
    init = function()
        require("legendary").command({
            ":ChatGPT",
            description = "ChatGPT: Chat",
        })
        require("legendary").command({
            ":ChatGPTRun",
            description = "ChatGPT: Run",
        })
        require("legendary").command({
            ":ChatGPTActAs",
            description = "ChatGPT: Act as",
        })
        require("legendary").command({
            ":ChatGPTEditWithInstructions",
            description = "ChatGPT: Edit with instructions",
        })

        require("legendary").commands({

            {
                ":ChatGPTGrammarCorrection",
                ":ChatGPTRun grammar_correction",
                description = "ChatGPT: grammar_correction",
            },
            {
                ":ChatGPTTranslate",
                ":ChatGPTRun translate",
                description = "ChatGPT: translate",
            },
            {
                ":ChatGPTKeywords",
                ":ChatGPTRun keywords",
                description = "ChatGPT: keywords",
            },
            {
                ":ChatGPTDocstring",
                ":ChatGPTRun docstring",
                description = "ChatGPT: docstring",
            },
            {
                ":ChatGPTAddTests",
                ":ChatGPTRun add_tests",
                description = "ChatGPT: add_tests",
            },
            {
                ":ChatGPTOptimizeCode",
                ":ChatGPTRun optimize_code",
                description = "ChatGPT: optimize_code",
            },
            {
                ":ChatGPTSummarize",
                ":ChatGPTRun summarize",
                description = "ChatGPT: summarize",
            },
            {
                ":ChatGPTFixBugs",
                ":ChatGPTRun fix_bugs",
                description = "ChatGPT: fix_bugs",
            },
            {
                ":ChatGPTExplainCode",
                ":ChatGPTRun explain_code",
                description = "ChatGPT: explain_code",
            },
            {
                ":ChatGPTRoxygenEdit",
                ":ChatGPTRun roxygen_edit",
                description = "ChatGPT: roxygen_edit",
            },
            {
                ":ChatGPTCodeReadabilityAnalysis",
                ":ChatGPTRun code_readability_analysis",
                description = "ChatGPT: code_readability_analysis",
            }, -- see [demo](https://youtu.be/zlU3YGGv2zY),
        })
    end,
}
