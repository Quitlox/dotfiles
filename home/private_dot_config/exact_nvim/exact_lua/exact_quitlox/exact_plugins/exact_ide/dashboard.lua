return {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
        require("dashboard").setup({
            config = {
                week_header = {
                    enable = true,
                },
                shortcut = {
                    {
                        icon = "󰊳 ",
                        desc = " Update",
                        group = "Number",
                        action = "Lazy update",
                        key = "u",
                    },
                    {
                        icon = " ",
                        icon_hl = "Label",
                        desc = " Files",
                        group = "Label",
                        action = "Telescope find_files",
                        key = "f",
                    },

                    -- {
                    --     icon = " ",
                    --     desc = " Dotfiles",
                    --     group = "@propery",
                    --     action = "lua require'telescope'.builtin.find_files({cwd='~/.config'})",
                    --     key = "d",
                    -- },
                },
                project = {
                    enable = true,
                    limit = 8,
                    icon = " ",
                    action = function(path)
                        vim.cmd("cd " .. path)
                        require("auto-session").AutoRestoreSession(path)
                        require("neo-tree.command").execute({ action = "focus" })
                    end,
                    label = " Projects",
                    key = "p",
                },
                mru = { limit = 8, label = " Most Recent Files", cwd_only = false },
            },
        })
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
