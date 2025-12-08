-- +---------------------------------------------------------+
-- | windwp/nvim-ts-autotag: Auto close HTML tags            |
-- +---------------------------------------------------------+

require("nvim-ts-autotag").setup({
    opts = {
        -- Defaults
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = true, -- Auto close on trailing </
    },
    -- Also override individual filetype configs, these take priority.
    -- Empty by default, useful if one of the "opts" global settings
    -- doesn't work well in a specific filetype
    per_filetype = {
        ["python"] = {
            enable_close = false,
        },
        ["rust"] = {
            enable_close = false,
        },
        ["text"] = {
            enable_close = false,
        },
        ["html"] = {
            enable_close = false,
        },
        ["markdown"] = {
            enable_close = false,
        },
        ["tex"] = {
            enable_close = false,
        },
    },
})
