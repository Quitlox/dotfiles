return {
    {
        "harrisoncramer/gitlab.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "stevearc/dressing.nvim", -- Recommended but not required. Better UI for pickers.
            "nvim-tree/nvim-web-devicons", -- Recommended but not required. Icons in discussion tree.
        },
        build = function() require("gitlab.server").build(true) end, -- Builds the Go binary
        opts = {
            help = "?", -- Opens a help popup for local keymaps when a relevant view is focused (popup, discussion panel, etc)
            popup = { -- The popup for comment creation, editing, and replying
                exit = "<Esc>",
                perform_action = "<leader>s", -- Once in normal mode, does action (like saving comment or editing description, etc)
                perform_linewise_action = "<leader>l", -- Once in normal mode, does the linewise action (see logs for this job, etc)
            },
            discussion_tree = { -- The discussion tree that holds all comments
                switch_view = "T", -- Toggles between the notes and discussions views
                default_view = "discussions", -- Show "discussions" or "notes" by default
                blacklist = {}, -- List of usernames to remove from tree (bots, CI, etc)
                jump_to_file = "o", -- Jump to comment location in file
                jump_to_reviewer = "m", -- Jump to the location in the reviewer window
                edit_comment = "e", -- Edit comment
                delete_comment = "dd", -- Delete comment
                reply = "r", -- Reply to comment
                toggle_node = "t", -- Opens or closes the discussion
                toggle_resolved = "p", -- Toggles the resolved status of the whole discussion
                position = "left", -- "top", "right", "bottom" or "left"
                open_in_browser = "b", -- Jump to the URL of the current note/discussion
                tree_type = "simple", -- Type of discussion tree - "simple" means just list of discussions, "by_file_name" means file tree with discussions under file
            },
            discussion_sign_and_diagnostic = {
                skip_resolved_discussion = false,
                skip_old_revision_discussion = true,
            },
            discussion_diagnostic = {
                severity = vim.diagnostic.severity.WARN,
            },
            merge = { -- The default behaviors when merging an MR, see "Merging an MR"
                squash = false,
                delete_branch = true,
            },
        },
        keys = {
            { "<leader>glr", "<cmd>require('gitlab').review()<cr>", desc = "Gitlab Review" },
            { "<leader>gls", "<cmd>require('gitlab').summary()<cr>", desc = "Gitlab Summary" },
            { "<leader>glA", "<cmd>require('gitlab').approve()<cr>", desc = "Gitlab Approve" },
            { "<leader>glR", "<cmd>require('gitlab').revoke()<cr>", desc = "Gitlab Revoke" },
            { "<leader>glc", "<cmd>require('gitlab').create_comment()<cr>", desc = "Gitlab Create Comment" },
            { "<leader>glc", "<cmd>require('gitlab').create_multiline_comment()<cr>", desc = "Gitlab Create Multiline Comment", mode = "v" },
            { "<leader>glC", "<cmd>require('gitlab').create_comment_suggestion()<cr>", desc = "Gitlab Create Comment Suggestion", mode = "v" },
            { "<leader>glO", "<cmd>require('gitlab').create_mr()<cr>", desc = "Gitlab Create MR" },
            { "<leader>glm", "<cmd>require('gitlab').move_to_discussion_tree_from_diagnostic()<cr>", desc = "Gitlab Move to Discussion Tree from Diagnostic" },
            { "<leader>gln", "<cmd>require('gitlab').create_note()<cr>", desc = "Gitlab Create Note" },
            { "<leader>gld", "<cmd>require('gitlab').toggle_discussions()<cr>", desc = "Gitlab Toggle Discussions" },
            { "<leader>glaa", "<cmd>require('gitlab').add_assignee()<cr>", desc = "Gitlab Add Assignee" },
            { "<leader>glad", "<cmd>require('gitlab').delete_assignee()<cr>", desc = "Gitlab Delete Assignee" },
            { "<leader>glla", "<cmd>require('gitlab').add_label()<cr>", desc = "Gitlab Add Label" },
            { "<leader>glld", "<cmd>require('gitlab').delete_label()<cr>", desc = "Gitlab Delete Label" },
            { "<leader>glra", "<cmd>require('gitlab').add_reviewer()<cr>", desc = "Gitlab Add Reviewer" },
            { "<leader>glrd", "<cmd>require('gitlab').delete_reviewer()<cr>", desc = "Gitlab Delete Reviewer" },
            { "<leader>glp", "<cmd>require('gitlab').pipeline()<cr>", desc = "Gitlab Pipeline" },
            { "<leader>glo", "<cmd>require('gitlab').open_in_browser()<cr>", desc = "Gitlab Open in Browser" },
            { "<leader>glM", "<cmd>require('gitlab').merge()<cr>", desc = "Gitlab Merge" },
        },
        init = function()
            vim.api.nvim_create_user_command("SetTNOGitlabToken", function(args)
                local Terminal = require("toggleterm.terminal").Terminal
                Terminal:new({
                    id = 97, -- Random high number
                    direction = "float",
                    cmd = [[
                        rm .gitlab.nvim && \
                        touch .gitlab.nvim && \
                        echo -n "auth_token=" >> .gitlab.nvim && \
                        bw get item "ci.tno.nl" | jq '.fields[] | select(.name == "Access Token (Neovim)").value' >> .gitlab.nvim && \
                        echo -n "gitlab_url=https://ci.tno.nl" >> .gitlab.nvim
                        ]],
                }):open()
            end, {
                desc = "Configure TNO Gitlab in this repository.",
            })
        end,
    },
    require("quitlox.util").legendary({
        { ":SetTNOGitlabToken", "Configure TNO Gitlab in this repository." },
    }),
}
