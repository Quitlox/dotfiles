-- +---------------------------------------------------------+
-- | NeogitOrg/neogit: Neogit                                |
-- +---------------------------------------------------------+

-- Update the signcolumn on neogit event
vim.api.nvim_create_autocmd("User", {
    pattern = { "NeogitCommitComplete", "NeogitStatusRefreshed", "NeogitBranchReset", "NeogitRebase", "NeogitReset" },
    group = vim.api.nvim_create_augroup("MyNeogitCommitEvents", { clear = true }),
    desc = "Update the signcolumn on neogit event",
    callback = function()
        require("gitsigns").reset_base()
    end,
})

require("neogit").setup({
    kind = "split",
    integrations = {
        diffview = true,
    },
    mappings = {
        commit_editor = {
            ["<C-k>"] = "Abort",
        },
        rebase_editor = {
            ["p"] = false,
            ["r"] = false,
            ["e"] = false,
            ["s"] = false,
            ["f"] = false,
            ["d"] = false,
            ["b"] = false,
            ["gp"] = "Pick",
            ["gr"] = "Reword",
            ["ge"] = "Edit",
            ["gs"] = "Squash",
            ["gf"] = "Fixup",
            ["gd"] = "Drop",
            ["gb"] = "Break",
        },
    },
})

-- Keymaps
vim.keymap.set("n", "<leader>og", "<cmd>Neogit<cr>", { noremap = true, silent = true, desc = "Open Git Status" })
