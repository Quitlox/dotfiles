-- +---------------------------------------------------------+
-- | CopilotC-Nvim/CopilotChat.nvim                          |
-- +---------------------------------------------------------+

--+- Setup --------------------------------------------------+
require("CopilotChat").setup({
    model = "claude-3.7-sonnet",
    auto_insert_mode = true,
    question_header = "  " .. "User" .. " ",
    answer_header = "  Copilot ",
    window = {
        width = 0.4,
    },
})

--+- Autocommand: Configure Options -------------------------+
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "copilot-chat",
    callback = function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
    end,
})

--+- Keymap -------------------------------------------------+
-- stylua: ignore start
vim.keymap.set({ "n", "v" }, "<leader><leader>aa", function() return require("CopilotChat").toggle() end, { desc = "Toggle (CopilotChat)" })
vim.keymap.set({ "n", "v" }, "<leader><leader>ax", function() return require("CopilotChat").reset() end, { desc = "Clear (CopilotChat)" })
vim.keymap.set({ "n", "v" }, "<leader><leader>ap", function() require("CopilotChat").select_prompt() end, { desc = "Prompt Actions (CopilotChat)" })
vim.keymap.set({ "n", "v" }, "<leader><leader>aq", function()
    vim.ui.input({ prompt = "Quick Chat: " }, function(input)
        if input ~= "" then
            require("CopilotChat").ask(input)
        end
    end)
end, { desc = "Quick Chat (CopilotChat)" })
-- stylua: ignore end

require("which-key").add({
    { "<leader><leader>a", group = "AI" },
})
