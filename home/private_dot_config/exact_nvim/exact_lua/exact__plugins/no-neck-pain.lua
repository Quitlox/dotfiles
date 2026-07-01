-- +---------------------------------------------------------+
-- | shortcuts/no-neck-pain.nvim                             |
-- +---------------------------------------------------------+

local constants = require("no-neck-pain.util.constants")

local edgy_integrations = {
    GrugFar = { fileTypePattern = "grug-far", position = "right" },
    CopilotChat = { fileTypePattern = "copilot-chat", position = "right" },
    CodeCompanion = { fileTypePattern = "codecompanion", position = "right" },
    Sidekick = { fileTypePattern = "sidekick", position = "right" },
    SnacksTerminal = { fileTypePattern = "snacks_terminal", position = "none" },
    Overseer = { fileTypePattern = "overseer", position = "none" },
    Neogit = { fileTypePattern = "neogit", position = "none" },
    Gitlab = { fileTypePattern = "gitlab", position = "none" },
    Trouble = { fileTypePattern = "trouble", position = "none" },
    QuickFix = { fileTypePattern = "qf", position = "none" },
    Help = { fileTypePattern = "help", position = "none" },
    Spectre = { fileTypePattern = "spectre", position = "none" },
    QuickTest = { fileTypePattern = "quicktest", position = "none" },
    OutputPanel = { fileTypePattern = "outputpanel", position = "none" },
}

for name, spec in pairs(edgy_integrations) do
    constants.INTEGRATIONS[name] = {
        fileTypePattern = spec.fileTypePattern,
        close = "",
        open = "",
    }
end

local integrations_config = {}
for name, spec in pairs(edgy_integrations) do
    integrations_config[name] = { position = spec.position, reopen = false }
end

require("no-neck-pain").setup({
    width = 120,
    autocmds = {
        skipEnteringNoNeckPainBuffer = true,
    },
    integrations = integrations_config,
})

vim.g.toggle_no_neck_pain = false

Snacks.toggle
    .new({
        name = "Neck Pain",
        set = function(state)
            require("no-neck-pain").toggle()
            vim.g.toggle_no_neck_pain = state
        end,
        get = function()
            return vim.g.toggle_no_neck_pain
        end,
    })
    :map("yon")
