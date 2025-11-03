-- +---------------------------------------------------------+
-- | mistricky/codesnap.nvim                                 |
-- +---------------------------------------------------------+

require("codesnap").setup({
    mac_window_bar = false,
    title = "",

    code_font_family = "CaskaydiaCove Nerd Font",
    watermark_font_family = "Pacifico",
    watermark = "",
    bg_color = "#535c68",
    breadcrumbs_separator = "/",
    has_breadcrumbs = false,
    has_line_number = true,

    show_workspace = false,
    min_width = 0,
    bg_x_padding = 0,
    bg_y_padding = 0,
    save_path = os.getenv("XDG_PICTURES_DIR") or (os.getenv("HOME") .. "/Pictures"),
})
