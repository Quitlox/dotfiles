-- Update the statusline when the git signs are updated
vim.api.nvim_create_autocmd("User", {
    pattern = "GitSignsUpdate",
    group = vim.api.nvim_create_augroup("NeogitRefreshEvents", {}),
    callback = function()
        require("neogit").refresh_manually(vim.api.nvim_buf_get_name(0))
    end,
})

return {
    "NeogitOrg/neogit",
    opts = {
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
    },
    cmd = { "Neogit" },
    keys = {
        { "<leader>og", "<cmd>Neogit<cr>", desc = "Open Git Status" },
        { "<leader>gs", "<cmd>Neogit<cr>", desc = "Git Status" },
        { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
    },
}
