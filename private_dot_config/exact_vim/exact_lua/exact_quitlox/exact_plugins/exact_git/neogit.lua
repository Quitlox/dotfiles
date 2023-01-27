return {
    "TimUntersberger/neogit",
    config = true,
    opts = {
        kind = "split",
        integrations = {
            diffview = true,
        },
    },
    cmd = {
        "Neogit",
        "NeogitStatus",
        "NeogitLog",
        "NeogitCommit",
        "NeogitBlame",
        "NeogitPush",
        "NeogitPull",
        "NeogitFetch",
        "NeogitCheckout",
        "NeogitBranch",
        "NeogitStash",
        "NeogitReset",
        "NeogitDiscard",
        "NeogitMerge",
        "NeogitRebase",
        "NeogitCherryPick",
        "NeogitRemote",
        "NeogitGrep",
        "NeogitHelp",
    },
    init = function()
        require("which-key").register({
            s = { "<cmd>Neogit<cr>", "Git Status" },
            c = { "<cmd>Neogit commit<cr>", "Git Commit" },
            -- Misc Telescope stuff
            b = { "<cmd>Telescope git_branches<cr>", "Open Git Branches" },
        }, { prefix = "<leader>g" })
    end,
}
