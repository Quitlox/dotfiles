-- +---------------------------------------------------------+
-- | akinsho/bufferline.nvim: Bufferline                     |
-- +---------------------------------------------------------+

--+- Function: Close Other Buffers --------------------------+
local function close_all_but_current()
    local current = vim.api.nvim_get_current_buf()
    local buffers = require("bufferline.utils").get_valid_buffers()
    for _, bufnr in pairs(buffers) do
        -- We leave the current buffer open
        if bufnr == current then
            goto continue
        end

        -- We leave buffers that are visible in a window
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(win) == bufnr then
                goto continue
            end
        end

        -- Delete the buffer
        -- require("bufferline.commands").handle_close(bufnr)
        pcall(vim.cmd, string.format("bd %d", bufnr))

        ::continue::
    end
end

--+- Options ------------------------------------------------+
-- Set the sessionoptions to include globals
-- Used to store the order of buffers
vim.opt.sessionoptions:append("globals")

--+- Setup --------------------------------------------------+
require("bufferline").setup({
    -- highlights = require("catppuccin.groups.integrations.bufferline").get(),
    options = {
        themable = true,
        diagnostics = "nvim_lsp",
        show_close_icon = false,
        show_tab_indicators = true,

        buffer_close_icon = " ",
        modified_icon = " ",
        close_icon = " ",
        -- left_trunc_marker = " ",
        -- right_trunc_marker = " ",

        -- Insert space for padding
        get_element_icon = function(element)
            local icon, hl = require("nvim-web-devicons").get_icon_by_filetype(element.filetype, { default = false })
            if icon == nil then
                return nil
            end
            return icon .. " ", hl
        end,
    },
})

--+- Keymaps ------------------------------------------------+
-- stylua: ignore start
vim.keymap.set("n", "<leader>bb", "<cmd>BufferLinePick<cr>", { desc = "Buffer Pick" })
vim.keymap.set("n", "<leader>bd", function() require('snacks').bufdelete() end, { desc = "Buffer Delete" })
vim.keymap.set("n", "<leader>bo", close_all_but_current, { desc = "Buffer Only" })
-- stylua: ignore end

vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })

vim.keymap.set("n", "<leader>bmn", "<cmd>BufferLineMoveNext<cr>", { desc = "Buffer Move Next" })
vim.keymap.set("n", "<leader>bmp", "<cmd>BufferLineMovePrev<cr>", { desc = "Buffer Move Prev" })

require("which-key").add({
    { "<leader>bm", group = "Buffer Move" },
    { "<leader>b", group = "Buffer" },
})

--+- Integration: Edgy --------------------------------------+
local offset = require("bufferline.offset")
if not offset.edgy then
    local get = offset.get
    offset.get = function()
        if package.loaded.edgy then
            local layout = require("edgy.config").layout
            local ret = { left = "", left_size = 0, right = "", right_size = 0 }
            for _, pos in ipairs({ "left", "right" }) do
                local sb = layout[pos]
                if sb and #sb.wins > 0 then
                    local title = " " .. string.rep(" ", sb.bounds.width - 1)
                    ret[pos] = "%#EdgyTitle#" .. title .. "%*" .. "%#EdgyTitle# %*"
                    ret[pos .. "_size"] = sb.bounds.width
                end
            end
            ret.total_size = ret.left_size + ret.right_size
            if ret.total_size > 0 then
                return ret
            end
        end
        return get()
    end
    offset.edgy = true
end
