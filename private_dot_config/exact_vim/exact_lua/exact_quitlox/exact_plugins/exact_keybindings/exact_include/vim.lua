----------------------------------------------------------------------
--                         Keybindings: Vim                         --
----------------------------------------------------------------------

require("quitlox.util.which_key").register({
    ["<leader>"] = {
        v = {
            name = "Vim",
            l = {
                name = "List",
                f = { "<cmd>Telescope filetypes theme=dropdown<cr>", "Vim List Filetypes" },
                r = { "<cmd>Telescope registers theme=dropdown<cr>", "Vim List Registers" },
                o = { "<cmd>Telescope vim_options theme=dropdown<cr>", "Vim List Options" },
                a = { "<cmd>Telescope autocommands theme=dropdown<cr>", "Vim List Autocommands" },
                h = { "<cmd>Telescope highlights theme=dropdown<cr>", "Vim List Highlights" },
                c = { "<cmd>Telescope commands theme=dropdown<cr>", "Vim List Commands" },
            },
        },
    },
})
