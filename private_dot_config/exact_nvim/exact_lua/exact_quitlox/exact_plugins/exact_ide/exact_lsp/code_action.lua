return {
    {
        "luckasRanarison/clear-action.nvim",
        opts = {
            signs = {
                icons = {
                    quickfix = " ", -- "🔧",
                    refactor = " ", -- "💡",
                    source = " ", -- "🔗",
                    combined = " ", -- "💡",
                },
            },
            mappings = {
                code_action = { key = "ga", options = { desc = "Code Action" } },
            },
        },
        event = "LspAttach",
    },
    require("quitlox.util").legendary({
        { ":CodeActionToggleSigns", "Toggle code action signs" },
        { ":CodeActionToggleLabel", "Toggle code action labels" },
    }),
}
