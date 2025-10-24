-- +---------------------------------------------------------+
-- | folke/sidekic.nvim: Copilot Next Edit & Agent CLI       |
-- +---------------------------------------------------------+

require("sidekick").setup({
    cli = {
        keys = {
            stopinsert = { "<c-o>", "stopinsert", mode = "t" }, -- enter normal mode
            win_p = { "<c-h>", "blur" },
        },
    },
})

-- stylua: ignore start
vim.keymap.set("n", "<tab>", function() if not require("sidekick").nes_jump_or_apply() then return "<Tab>" end end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })
vim.keymap.set("n", "<leader>aa", require("sidekick.cli").toggle, { desc = "Sidekick Toggle CLI" })
vim.keymap.set("n", "<leader>as", require("sidekick.cli").select, { desc = "Select CLI" })
vim.keymap.set({ "x", "n" }, "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end, { desc = "Send This" })
vim.keymap.set("x", "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end, { desc = "Send Visual Selection" })
vim.keymap.set({ "n", "x" }, "<leader>ap", require("sidekick.cli").prompt, { desc = "Sidekick Select Prompt" })
vim.keymap.set({ "n", "x", "i", "t" }, "<c-.>", require("sidekick.cli").focus, { desc = "Sidekick Switch Focus" })
-- vim.keymap.set("n", "<leader>ac", function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end, { desc = "Sidekick Toggle Claude" })
-- stylua: ignore end

require("which-key").add({
    { "<leader>a", group = "Agent/AI" },
})
