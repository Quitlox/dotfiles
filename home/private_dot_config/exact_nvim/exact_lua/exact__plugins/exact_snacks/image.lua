-- +---------------------------------------------------------+
-- | snacks.nvim: Image                                      |
-- +---------------------------------------------------------+

local image_opts = {
    enabled = vim.fn.has("wsl") ~= 1,
    doc = { inline = false, float = true, conceal = true },
    math = { enabled = false, latex = { font_size = "Large" } },
}

return image_opts
