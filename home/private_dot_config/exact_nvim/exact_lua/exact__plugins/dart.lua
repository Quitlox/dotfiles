-- +---------------------------------------------------------+
-- | iofq/dart.nvim: Bufferline                              |
-- +---------------------------------------------------------+

require("dart").setup({
    tabline = {
        always_show = false,
    },
    mappings = {
        mark = "Mm",
        jump = "M",
        pick = "Mp",
        next = "[b",
        prev = "]b",
        unmark_all = "Mu",
    },
})

local function disable_underline(group)
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
    if not ok then
        return
    end
    hl.underline = false
    vim.api.nvim_set_hl(0, group, hl)
end

for _, group in ipairs({
    "DartCurrent",
    "DartCurrentLabel",
    "DartMarkedCurrent",
    "DartMarkedCurrentLabel",
    "DartMarkedCurrentModified",
    "DartMarkedCurrentLabelModified",
}) do
    disable_underline(group)
end
