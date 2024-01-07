return {
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
            code_action = "ga",
        },
    },
    event = "LspAttach",
    init = function()
        require("legendary").commands({
            { ":CodeActionToggleSigns", description = "Toggle code action signs" },
            { ":CodeActionToggleLabel", description = "Toggle code action labels" },
        })
    end,
}
