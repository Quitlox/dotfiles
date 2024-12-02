-- +---------------------------------------------------------+
-- | akinsho/bufferline.nvim: Bufferline                     |
-- +---------------------------------------------------------+

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
            if icon == nil then return nil end
            return icon .. " ", hl
        end,
    },
})

--+- Keymaps ------------------------------------------------+
vim.keymap.set("n", "<leader>bb", "<cmd>BufferLinePick<cr>", { desc = "Buffer Pick" })
vim.keymap.set("n", "<leader>bd", ":lua require('snacks').bufdelete()<cr>", { desc = "Buffer Delete" })
vim.keymap.set("n", "<leader>bo", ":lua require('snacks').bufdelete.other()<cr>", { desc = "Buffer Only" })

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
            if ret.total_size > 0 then return ret end
        end
        return get()
    end
    offset.edgy = true
end
