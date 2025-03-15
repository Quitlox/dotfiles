-- +---------------------------------------------------------+
-- | CopilotC-Nvim/CopilotChat.nvim                          |
-- +---------------------------------------------------------+

--+- Setup --------------------------------------------------+
require("CopilotChat").setup({
    model = "claude-3.7-sonnet",
    auto_insert_mode = false,
    question_header = "  " .. "User" .. " ",
    answer_header = "  Copilot ",
    window = {
        width = 0.4,
    },

    prompts = {
        AnsibleTaskNaming = {
            system_prompt = [[
When writing Ansible tasks, follow these naming conventions:
1. Use sentence case with action verbs in present tense (e.g., "Install packages" not "Installing packages")
2. Be specific and descriptive about what the task accomplishes
3. For hierarchical tasks, use a structure where:
   - Top-level names describe the overall function (e.g., "Configure system parameters")
   - Mid-level names describe logical groupings (e.g., "Set up networking components")
   - Low-level names describe specific actions (e.g., "Create network interfaces file")
4. Include the affected component or subsystem in the name when appropriate
5. Avoid technical jargon in task names unless necessary for clarity
6. Keep names concise but informative, generally under 80 characters
            ]],
        },
    },
})

--+- Autocommand: Configure Options -------------------------+
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "copilot-chat",
    callback = function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false

        vim.opt_local.completeopt = "menu,popup,noinsert,noselect"

        vim.keymap.set("i", "<Tab>", function()
            if vim.fn.pumvisible() == 1 then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-n>", true, false, true), "n", false)
            else
                -- Default mapping set by CopilotChat
                require("CopilotChat").trigger_complete()
            end
        end, { buffer = 0, noremap = true })

        vim.keymap.set("i", "<S-Tab>", function()
            if vim.fn.pumvisible() == 1 then
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-p>", true, false, true), "n", false)
            else
                -- Pass through default mapping
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n", false)
            end
        end, { buffer = 0, noremap = true })
    end,
})

--+- Keymap -------------------------------------------------+
-- stylua: ignore start
vim.keymap.set({ "n", "v" }, "<leader>cc", function() return require("CopilotChat").toggle() end, { desc = "Toggle (CopilotChat)" })
vim.keymap.set({ "n", "v" }, "<leader>cx", function() return require("CopilotChat").reset() end, { desc = "Clear (CopilotChat)" })
vim.keymap.set({ "n", "v" }, "<leader>cp", function() require("CopilotChat").select_prompt() end, { desc = "Prompt Actions (CopilotChat)" })
vim.keymap.set({ "n", "v" }, "<leader>cq", function()
    vim.ui.input({ prompt = "Quick Chat: " }, function(input)
        if input ~= "" then
            require("CopilotChat").ask(input)
        end
    end)
end, { desc = "Quick Chat (CopilotChat)" })
-- stylua: ignore end

require("which-key").add({
    { "<leader>c", group = "AI" },
})
