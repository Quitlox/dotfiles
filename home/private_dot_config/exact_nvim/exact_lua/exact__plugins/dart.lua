-- +---------------------------------------------------------+
-- | iofq/dart.nvim: Bufferline                              |
-- +---------------------------------------------------------+

require("dart").setup({
    tabline = {
        always_show = false,
        -- Reverse tabline order: first show marked buffers, then recent
        order = function()
            local order = {}
            for i, key in ipairs(vim.list_extend(vim.deepcopy(Dart.config.marklist), Dart.config.buflist)) do
                order[key] = i
            end
            return order
        end,
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

require("which-key").add({
    { "Mm", desc = "Dart: mark" },
    { "M", group = "Dart: jump" },
    { "Mp", desc = "Dart: pick" },
    { "[b", desc = "Dart: prev" },
    { "]b", desc = "Dart: next" },
    { "Mu", desc = "Dart: unmark" },
})

--+- Aestethic: Remove underline ----------------------------+
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
