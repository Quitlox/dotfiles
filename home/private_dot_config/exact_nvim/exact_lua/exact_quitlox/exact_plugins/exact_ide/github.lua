return {
    {
        "pwntester/octo.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        cmd = { "Octo" },
        keys = {
            { "<leader>gho", "<cmd>Octo<cr>", desc = "Github Open" },
            { "<leader>ghpl", "<cmd>Octo pr list<cr>", desc = "Github Pull-request List" },
        },
        opts = {
            enable_builtin = true,
            mappings = {
                issue = {
                    close_issue = { lhs = "<space>ghic", desc = "Issue Close" },
                    reopen_issue = { lhs = "<space>ghio", desc = "Issue Re-open" },
                    list_issues = { lhs = "<space>ghil", desc = "Issue List" },
                    reload = { lhs = "<C-r>", desc = "Reload issue" },
                    open_in_browser = { lhs = "<C-b>", desc = "Open issue in browser" },
                    -- copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
                    add_assignee = { lhs = "<space>ghaa", desc = "Assignee Add" },
                    remove_assignee = { lhs = "<space>ghad", desc = "Assignee Remove" },
                    -- create_label = { lhs = "<space>lc", desc = "create label" },
                    add_label = { lhs = "<space>ghla", desc = "Label Add" },
                    remove_label = { lhs = "<space>ghld", desc = "Label Remove" },
                    -- goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
                    add_comment = { lhs = "<space>ghca", desc = "Comment Add" },
                    delete_comment = { lhs = "<space>ghcd", desc = "Comment Delete" },
                    next_comment = { lhs = "]c", desc = "Go to next comment" },
                    prev_comment = { lhs = "[c", desc = "Go to previous comment" },
                    -- react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
                    -- react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
                    -- react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
                    -- react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
                    -- react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
                    -- react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
                    -- react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
                    -- react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
                },
                pull_request = {
                    checkout_pr = { lhs = "<space>ghpc", desc = "Pull-request Checkout" },
                    merge_pr = { lhs = "<space>ghpm", desc = "Pull-request Merge" },
                    squash_and_merge_pr = { lhs = "<space>psm", desc = "squash and merge PR" },
                    -- list_commits = { lhs = "<space>pc", desc = "list PR commits" },
                    -- list_changed_files = { lhs = "<space>pf", desc = "list PR changed files" },
                    -- show_pr_diff = { lhs = "<space>pd", desc = "show PR diff" },
                    -- add_reviewer = { lhs = "<space>va", desc = "add reviewer" },
                    -- remove_reviewer = { lhs = "<space>vd", desc = "remove reviewer request" },
                    close_issue = { lhs = "<space>ghpc", desc = "Pull-request Close" },
                    reopen_issue = { lhs = "<space>ghpo", desc = "Pull-request Re-open" },
                    list_issues = { lhs = "<space>ghil", desc = "Issue List" },
                    -- reload = { lhs = "<C-r>", desc = "reload PR" },
                    open_in_browser = { lhs = "<C-b>", desc = "Open Pull-request in browser" },
                    -- copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
                    -- goto_file = { lhs = "gf", desc = "go to file" },
                    add_assignee = { lhs = "<space>ghaa", desc = "Assignee Add" },
                    remove_assignee = { lhs = "<space>ghad", desc = "Assignee Remove" },
                    -- create_label = { lhs = "<space>lc", desc = "create label" },
                    -- add_label = { lhs = "<space>la", desc = "add label" },
                    -- remove_label = { lhs = "<space>ld", desc = "remove label" },
                    -- goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
                    add_comment = { lhs = "<space>ghca", desc = "Comment Add" },
                    delete_comment = { lhs = "<space>ghcd", desc = "Comment Delete" },
                    next_comment = { lhs = "]c", desc = "Go to next comment" },
                    prev_comment = { lhs = "[c", desc = "Go to previous comment" },
                    -- react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
                    -- react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
                    -- react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
                    -- react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
                    -- react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
                    -- react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
                    -- react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
                    -- react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
                },
                review_thread = {
                    -- goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
                    add_comment = { lhs = "<space>ghca", desc = "Comment Add" },
                    add_suggestion = { lhs = "<space>ghsa", desc = "Suggestion Add" },
                    delete_comment = { lhs = "<space>ghcd", desc = "Comment Delete" },
                    next_comment = { lhs = "]c", desc = "Go to next comment" },
                    prev_comment = { lhs = "[c", desc = "Go to previous comment" },
                    -- select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
                    -- select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
                    -- select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
                    -- select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
                    close_review_tab = { lhs = "q", desc = "Close review tab" },
                    -- react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
                    -- react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
                    -- react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
                    -- react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
                    -- react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
                    -- react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
                    -- react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
                    -- react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
                },
                submit_win = {
                    -- approve_review = { lhs = "<C-a>", desc = "approve review" },
                    -- comment_review = { lhs = "<C-m>", desc = "comment review" },
                    -- request_changes = { lhs = "<C-r>", desc = "request changes review" },
                    close_review_tab = { lhs = "<C-c>", desc = "Close review tab" },
                },
                review_diff = {
                    add_review_comment = { lhs = "<space>ghca", desc = "Review Comment Add" },
                    add_review_suggestion = { lhs = "<space>ghsa", desc = "Review Suggestion Add" },
                    -- focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
                    -- toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
                    next_thread = { lhs = "]t", desc = "Move to next thread" },
                    prev_thread = { lhs = "[t", desc = "Move to previous thread" },
                    -- select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
                    -- select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
                    -- select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
                    -- select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
                    -- close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
                    toggle_viewed = { lhs = "<leader>ght", desc = "Toggle viewed state" },
                    -- goto_file = { lhs = "gf", desc = "go to file" },
                },
                file_panel = {
                    -- next_entry = { lhs = "j", desc = "move to next changed file" },
                    -- prev_entry = { lhs = "k", desc = "move to previous changed file" },
                    -- select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
                    refresh_files = { lhs = "<C-R>", desc = "Refresh changed files panel" },
                    -- focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
                    -- toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
                    -- select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
                    -- select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
                    -- select_first_entry = { lhs = "[Q", desc = "move to first changed file" },
                    -- select_last_entry = { lhs = "]Q", desc = "move to last changed file" },
                    close_review_tab = { lhs = "<C-c>", desc = "Close review tab" },
                    toggle_viewed = { lhs = "<leader>ght", desc = "Toggle viewed state" },
                },
            },
        },
    },
    require("quitlox.util").whichkey({
        { "<leader>gh", group = "Github" },
        { "<leader>ghc", group = "Comment" },
        { "<leader>ghi", group = "Issue" },
        { "<leader>ghp", group = "Pull-request" },
        { "<leader>gha", group = "Assignee" },
    }),
}
