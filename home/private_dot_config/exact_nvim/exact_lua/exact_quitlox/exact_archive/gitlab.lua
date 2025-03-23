-- +---------------------------------------------------------+
-- | harrisoncramer/gitlab.nvim: Gitlab Integration          |
-- +---------------------------------------------------------+

--+- Command: TNO Gitlab Token ------------------------------+
vim.api.nvim_create_user_command("SetTNOGitlabToken", function(args)
    local cmd = [[
        if [ -e .gitlab.nvim ]; then
            rm .gitlab.nvim
        fi
        touch .gitlab.nvim
        echo -n "auth_token=" >> .gitlab.nvim
        bw get item "ci.tno.nl" | jq '.fields[] | select(.name == "Access Token (Neovim)").value' >> .gitlab.nvim
        echo -n "gitlab_url=https://ci.tno.nl" >> .gitlab.nvim
    ]]
    Snacks.terminal.open(cmd)
end, {
    desc = "Configure TNO Gitlab in this repository.",
})

--+- Setup --------------------------------------------------+
local function setup_gitlab()
    require("gitlab.server").build(true)
    require("diffview") -- gitlab requires global state from diffview
    require("gitlab").setup({
        help = "?",
        discussion_tree = {
            switch_view = "T",
            jump_to_file = "i",
            toggle_node = "o",
            position = "bottom",
        },
    })
end

require("quitlox.util.lazy").require_stub("gitlab", setup_gitlab)

--+- Keymaps ------------------------------------------------+
-- stylua: ignore start
vim.keymap.set("n", "<leader>glr", function() require('gitlab').review() end, { noremap = true, silent = true, desc = "Gitlab Review" })
vim.keymap.set("n", "<leader>gls", function() require('gitlab').summary() end, { noremap = true, silent = true, desc = "Gitlab Summary" })
vim.keymap.set("n", "<leader>glA", function() require('gitlab').approve() end, { noremap = true, silent = true, desc = "Gitlab Approve" })
vim.keymap.set("n", "<leader>glR", function() require('gitlab').revoke() end, { noremap = true, silent = true, desc = "Gitlab Revoke" })
vim.keymap.set("n", "<leader>glc", function() require('gitlab').create_comment() end, { noremap = true, silent = true, desc = "Gitlab Create Comment" })
vim.keymap.set("v", "<leader>glc", function() require('gitlab').create_multiline_comment() end, { noremap = true, silent = true, desc = "Gitlab Create Multiline Comment" })
vim.keymap.set("v", "<leader>glC", function() require('gitlab').create_comment_suggestion() end, { noremap = true, silent = true, desc = "Gitlab Create Comment Suggestion" })
vim.keymap.set("n", "<leader>glO", function() require('gitlab').create_mr() end, { noremap = true, silent = true, desc = "Gitlab Create MR" })
vim.keymap.set("n", "<leader>glm", function() require('gitlab').move_to_discussion_tree_from_diagnostic() end, { noremap = true, silent = true, desc = "Gitlab Move to Discussion Tree from Diagnostic" }) 
vim.keymap.set("n", "<leader>gln", function() require('gitlab').create_note() end, { noremap = true, silent = true, desc = "Gitlab Create Note" })
vim.keymap.set("n", "<leader>gld", function() require('gitlab').toggle_discussions() end, { noremap = true, silent = true, desc = "Gitlab Toggle Discussions" })
vim.keymap.set("n", "<leader>glaa", function() require('gitlab').add_assignee() end, { noremap = true, silent = true, desc = "Gitlab Add Assignee" })
vim.keymap.set("n", "<leader>glda", function() require('gitlab').delete_assignee() end, { noremap = true, silent = true, desc = "Gitlab Delete Assignee" })
vim.keymap.set("n", "<leader>glal", function() require('gitlab').add_label() end, { noremap = true, silent = true, desc = "Gitlab Add Label" })
vim.keymap.set("n", "<leader>gldl", function() require('gitlab').delete_label() end, { noremap = true, silent = true, desc = "Gitlab Delete Label" })
vim.keymap.set("n", "<leader>glar", function() require('gitlab').add_reviewer() end, { noremap = true, silent = true, desc = "Gitlab Add Reviewer" })
vim.keymap.set("n", "<leader>gldr", function() require('gitlab').delete_reviewer() end, { noremap = true, silent = true, desc = "Gitlab Delete Reviewer" })
vim.keymap.set("n", "<leader>glp", function() require('gitlab').pipeline() end, { noremap = true, silent = true, desc = "Gitlab Pipeline" })
vim.keymap.set("n", "<leader>glo", function() require('gitlab').open_in_browser() end, { noremap = true, silent = true, desc = "Gitlab Open in Browser" })
vim.keymap.set("n", "<leader>glM", function() require('gitlab').merge({ squash = false, delete_branch = true }) end, { noremap = true, silent = true, desc = "Gitlab Merge" })
require('which-key').add({"<leader>gl", group = "Gitlab"})
-- stylua: ignore end
