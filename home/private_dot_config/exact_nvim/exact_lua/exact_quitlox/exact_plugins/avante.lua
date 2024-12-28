-- +---------------------------------------------------------+
-- | yetone/avante.nvim                                      |
-- +---------------------------------------------------------+

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3

require("avante_lib").load()
require("avante").setup(
    ---@class avante.Config
    {
        provider = "openai",

        mappings = {
            ask = "<leader>ua",
            edit = "<leader>ue",
            refresh = "<leader>ur",
            focus = "<leader>uf",

            toggle = {
                default = "<leader>ut",
                debug = "<leader>ud",
                hint = "<leader>uh",
                suggestion = "<leader>us",
                repomap = "<leader>uR",
            },

            --- @class AvanteConflictMappings
            diff = {
                ours = "co",
                theirs = "ct",
                all_theirs = "ca",
                both = "cb",
                cursor = "cc",
                next = "]x",
                prev = "[x",
            },
            suggestion = {
                accept = "<M-l>",
                next = "<M-]>",
                prev = "<M-[>",
                dismiss = "<C-]>",
            },
            jump = {
                next = "]]",
                prev = "[[",
            },
            submit = {
                normal = "<CR>",
                insert = "<C-s>",
            },
            sidebar = {
                apply_all = "A",
                apply_cursor = "a",
                switch_windows = "<Tab>",
                reverse_switch_windows = "<S-Tab>",
            },
        },
    }
)

require("legendary").commands({
    { ":AvanteAsk [question]", desc = "Ask AI about your code", unfinished = true },
    { ":AvanteBuild", desc = "Build dependencies for the project" },
    { ":AvanteChat", desc = "Start a chat session with AI about your codebase" },
    { ":AvanteEdit", desc = "Edit the selected code blocks" },
    { ":AvanteFocus", desc = "Switch focus to/from the sidebar" },
    { ":AvanteRefresh", desc = "Refresh all Avante windows" },
    { ":AvanteSwitchProvider", desc = "Switch AI provider (e.g. openai)" },
    { ":AvanteShowRepoMap", desc = "Show repo map for project's structure" },
    { ":AvanteToggle", desc = "Toggle the Avante sidebar" },
})
