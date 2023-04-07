----------------------------------------------------------------------
--                         Keybindings: Tab                         --
----------------------------------------------------------------------

require("quitlox.util.which_key").register({
    ["<leader>"] = {
        t = {
            name = "Tab",
            t = { ":tabnew<cr>", "Tab new" },
            o = { ":tabonly<cr>", "Tab Only" },
            d = { ":tabclose<cr>", "Tab Delete" },
            n = { ":tabnext<cr>", "Tab Next" },
            p = { ":tabprevious<cr>", "Tab Prev" },
            m = {
                name = "Move",
                h = { ":-tabmove<cr>", "Tab Move left" },
                l = { ":+tabmove<cr>", "Tab Move right" },
            },
        },
    },
})
