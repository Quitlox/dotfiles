return {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
        input = {
            win_options = {
                -- Window transparency (0-100)
                winblend = 0,
                -- Change default highlight groups (see :help winhl)
                winhighlight = "",
            },

            -- Set to `false` to disable
            mappings = {
                i = {
                    ["<C-c>"] = "Close",
                    ["<CR>"] = "Confirm",
                    ["<Up>"] = "HistoryPrev",
                    ["<Down>"] = "HistoryNext",
                    ["<C-p>"] = "HistoryPrev",
                    ["<C-n>"] = "HistoryNext",
                },
            },

            -- see :help dressing_get_config
            get_config = function(opts)
                -- We use the default input for renaming files, as its more convient for longer inputs
                if vim.api.nvim_buf_get_option(0, "filetype") == "NvimTree" then
                    -- https://github.com/stevearc/dressing.nvim/issues/29
                    return { enabled = false }
                end

                return opts
            end,
        },
        select = {

            -- Options for built-in selector
            builtin = {

                win_options = {
                    -- Window transparency (0-100)
                    winblend = 0,
                    -- Change default highlight groups (see :help winhl)
                    winhighlight = "",
                },
            },
        },
    },
}
