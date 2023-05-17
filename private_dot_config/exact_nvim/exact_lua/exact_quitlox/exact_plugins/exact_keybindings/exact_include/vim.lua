----------------------------------------------------------------------
--                         Keybindings: Vim                         --
----------------------------------------------------------------------

require("which-key").register({
    ["<leader>"] = {
        v = {
            name = "Vim",
            l = {
                name = "List",
                f = { "<cmd>Telescope filetypes theme=dropdown<cr>", "Filetypes" },
                r = { "<cmd>Telescope registers theme=dropdown<cr>", "Registers" },
                o = { "<cmd>Telescope vim_options theme=dropdown<cr>", "Options" },
                a = { "<cmd>Telescope autocommands theme=dropdown<cr>", "Autocommands" },
                h = { "<cmd>Telescope highlights theme=dropdown<cr>", "Highlights" },
                c = { "<cmd>Telescope commands theme=dropdown<cr>", "Commands" },
                u = {"<cmd>Telescope undo<cr>", "Undo"}
            },
        },
    },
})
