-- +---------------------------------------------------------+
-- | otavioschwanck/arrow.nvim: Buffer Bookmark              |
-- +---------------------------------------------------------+

function setup_arrow()
    require("arrow").setup({
        show_icons = true,
        leader_key = "=",
        mappings = {
            open_vertical = "b",
            open_horizontal = "v",
        },
    })
end

require("quitlox.util.lazy").keymap_stub("n", "=", setup_arrow, { noremap = true, silent = true })
