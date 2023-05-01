----------------------------------------
-- Bufferline: Keybindings
----------------------------------------

local function close_all_but_current()
    local current = vim.api.nvim_get_current_buf()
    local buffers = require("bufferline.utils").get_valid_buffers()
    for _, bufnr in pairs(buffers) do
        -- We leave the current buffer open
        if bufnr == current then goto continue end

        -- We leave buffers that are visible in a window
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(win) == bufnr then goto continue end
        end

        -- Delete the buffer
        -- require("bufferline.commands").handle_close(bufnr)
        pcall(vim.cmd, string.format("bd %d", bufnr))

        ::continue::
    end
end

----------------------------------------
-- Bufferline: Setup
----------------------------------------

return {
    {
        "akinsho/bufferline.nvim",
        version = "",
        config = function()
            local lazy = require("bufferline.lazy")
            local colors = lazy.require("bufferline.colors")

            local hex = colors.get_color
            local shade = colors.shade_color

            local normal_bg = hex({ name = "Normal", attribute = "bg" })

            local is_bright_background = colors.color_is_bright(normal_bg)
            local background_shading = is_bright_background and -12 or -25

            local visible_bg = shade(normal_bg, -8)
            local background_color = shade(normal_bg, background_shading)

            require("bufferline").setup({
                options = {
                    themable = true,
                    diagnostics = "nvim_lsp",
                    diagnostics_indicator = function(count, level, diagnostics_dict, context)
                        local icon = "  "
                        icon = level:match("warning") and "  " or icon
                        icon = level:match("error") and "  " or icon
                        return " " .. icon .. count
                    end,
                    offsets = {
                        {
                            filetype = "NvimTree",
                            text = "File Explorer",
                            text_align = "left",
                        },
                    },
                    color_icons = false,
                    show_buffer_default_icon = true,
                    separator_style = "slant",
                    buffer_close_icon = "",
                    close_icon = "",
                    indicator = {
                        style = "underline",
                    },
                    left_trunc_marker = "",
                    modified_icon = "●",
                    right_trunc_marker = "",
                    show_close_icon = false,
                    show_tab_indicators = true,
                    custom_areas = {
                        right = function()
                            local result = {}
                            local seve = vim.diagnostic.severity
                            local error = vim.diagnostic.get(0, { severity = seve.ERROR })
                            local warning = vim.diagnostic.get(0, { severity = seve.WARN })
                            local info = vim.diagnostic.get(0, { severity = seve.INFO })
                            local hint = vim.diagnostic.get(0, { severity = seve.HINT })

                            if error ~= 0 then table.insert(result, { text = "  " .. error, fg = c.vscRed }) end
                            if warning ~= 0 then
                                table.insert(result, { text = "  " .. warning, fg = c.vscYellowOrange })
                            end
                            if hint ~= 0 then table.insert(result, { text = "  " .. hint, fg = c.vscGreen }) end
                            if info ~= 0 then table.insert(result, { text = "  " .. info, fg = c.vscLightBlue }) end

                            return result
                        end,
                    },
                },
                -- Until https://github.com/akinsho/bufferline.nvim/issues/382 is resolved
                highlights = {
                    separator = {
                        fg = { attribute = "bg", highlight = "StatusLineNC" },
                        bg = background_color,
                    },
                    separator_selected = {
                        fg = { attribute = "bg", highlight = "StatusLineNC" },
                        bg = visible_bg,
                    },
                    separator_visible = {
                        fg = { attribute = "bg", highlight = "StatusLineNC" },
                        bg = background_color,
                    },
                    buffer = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                    buffer_visible = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                    buffer_selected = { fg = { attribute = "fg", highlight = "Normal" } },
                    close_button = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                    close_button_visible = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                    diagnostic = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                    diagnostic_visible = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                    error = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                    error_visible = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                    error_selected = { fg = { attribute = "fg", highlight = "Normal" } },
                    error_diagnostic = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                    error_diagnostic_visible = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                    warning = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                    warning_visible = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                    warning_selected = { fg = { attribute = "fg", highlight = "Normal" } },
                    warning_diagnostic = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                    warning_diagnostic_visible = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                    info = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                    info_visible = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                    info_selected = { fg = { attribute = "fg", highlight = "Normal" } },
                    info_diagnostic = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                    info_diagnostic_visible = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                    hint = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                    hint_visible = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                    hint_selected = { fg = { attribute = "fg", highlight = "Normal" } },
                    hint_diagnostic = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                    hint_diagnostic_visible = { fg = { attribute = "fg", highlight = "@tag.delimiter" } },
                },
            })
        end,
        init = function()
            require("which-key").register({
                b = {
                    name = "Buffer",
                    n = { "<cmd>BufferLineCycleNext<cr>", "Buffer Next" },
                    p = { "<cmd>BufferLineCyclePrev<cr>", "Buffer Prev" },
                    b = { "<cmd>BufferLinePick<cr>", "Buffer Pick" },
                    f = { "<cmd>Telescope buffers<cr>", "Buffer Find" },
                    d = { ":Bdelete<cr>", "Buffer Delete" },
                    o = { close_all_but_current, "Buffer Only" },
                    m = {
                        name = "Move",
                        n = { "<cmd>BufferLineMoveNext<cr>", "Buffer Move Next" },
                        p = { "<cmd>BufferLineMovePrev<cr>", "Buffer Move Prev" },
                    },
                },
            }, { prefix = "<leader>" })
        end,
    },
    {
        "roobert/bufferline-cycle-windowless.nvim",
        dependencies = {
            { "akinsho/bufferline.nvim" },
        },
        config = function()
            require("bufferline-cycle-windowless").setup({
                -- whether to start in enabled or disabled mode
                default_enabled = true,
            })
        end,
        init = function()
            require("which-key").register({
                n = { "<cmd>BufferLineCycleWindowlessNext<cr>", "Buffer Next" },
                p = { "<cmd>BufferLineCycleWindowlessPrev<cr>", "Buffer Prev" },
            }, { prefix = "<leader>b" })
        end,
    },
}

-- vim.cmd([[hi BufferLineSeparator guifg=c.c.vscFoldBackground]])
-- vim.cmd([[hi BufferLineSeparatorSelected guifg=c.vscFoldBackground]])
-- vim.cmd([[hi BufferLineSeparatorVisible guifg=c.vscFoldBackground]])
