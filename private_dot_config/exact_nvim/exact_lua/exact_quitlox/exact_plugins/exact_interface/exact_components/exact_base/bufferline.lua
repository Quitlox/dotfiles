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

-- Set the sessionoptions to include globals
-- Used to store the order of buffers
vim.opt.sessionoptions:append("globals")

return {
    {
        "akinsho/bufferline.nvim",
        version = "",
        config = function()
            local lazy = require("bufferline.lazy")

            require("bufferline").setup({
                options = {
                    themable = true,
                    diagnostics = "nvim_lsp",
                    show_close_icon = false,
                    show_tab_indicators = true,
                },
                highlights = require("catppuccin.groups.integrations.bufferline").get(),
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
