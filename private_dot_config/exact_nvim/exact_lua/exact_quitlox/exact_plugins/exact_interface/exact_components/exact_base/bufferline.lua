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
        "folke/which-key.nvim",
        optional = true,
        opts = {
            defaults = {
                ["<leader>bm"] = { name = "Buffer Move" },
                ["<leader>b"] = { name = "Buffer" },
            },
        },
    },
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        version = "",
        keys = {
            { "<leader>bn", "<cmd>BufferLineCycleNext<cr>", desc = "Buffer Next" },
            { "<leader>bp", "<cmd>BufferLineCyclePrev<cr>", desc = "Buffer Prev" },
            { "<leader>bb", "<cmd>BufferLinePick<cr>", desc = "Buffer Pick" },
            { "<leader>bf", "<cmd>Telescope buffers<cr>", desc = "Buffer Find" },
            { "<leader>bd", ":Bdelete<cr>", desc = "Buffer Delete" },
            { "<leader>bo", close_all_but_current, desc = "Buffer Only" },
            { "<leader>bmn", "<cmd>BufferLineMoveNext<cr>", desc = "Buffer Move Next" },
            { "<leader>bmp", "<cmd>BufferLineMovePrev<cr>", desc = "Buffer Move Prev" },
        },
        opts = {
            options = {
                themable = true,
                diagnostics = "nvim_lsp",
                show_close_icon = false,
                show_tab_indicators = true,
            },
            highlights = require("catppuccin.groups.integrations.bufferline").get(),
        },
    },
    {
        "roobert/bufferline-cycle-windowless.nvim",
        cmd = { "BufferLineCycleWindowlessNext", "BufferLineCycleWindowlessPrev" },
        keys = {
            { "<leader>bn", "<cmd>BufferLineCycleWindowlessNext<cr>", desc = "Buffer Next" },
            { "<leader>bp", "<cmd>BufferLineCycleWindowlessPrev<cr>", desc = "Buffer Prev" },
        },
        opts = {
            -- whether to start in enabled or disabled mode
            default_enabled = true,
        },
    },
}
