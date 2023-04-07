----------------------------------------------------------------------
--                       Keybindings: Window                        --
----------------------------------------------------------------------

-- Close the window if it is not the current window and
-- the filetype is not equals to 'NvimTree'
local function window_only()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if
            win ~= vim.api.nvim_get_current_win()
            and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), "filetype") ~= "NvimTree"
        then
            vim.api.nvim_win_close(win, false)
        end
    end
end

require("quitlox.util.which_key").register({
    ["<leader>"] = {
        w = {
            name = "Window",
            j = { "<C-W>j", "which_key_ignore" },
            k = { "<C-W>k", "which_key_ignore" },
            h = { "<C-W>h", "which_key_ignore" },
            l = { "<C-W>l", "which_key_ignore" },
            o = { window_only, "Window Only" },
            v = { "<C-W>s", "Window vSplit" },
            b = { "<C-W>v", "Window Split" },
            d = { "<C-W>q", "Window Delete" },
            w = { ":new<CR>", "New Window" },
            r = {
                name = "Resize",
                k = { ":resize +2<CR>", "Window Resize Up" },
                j = { ":resize -2<CR>", "Window Resize Down" },
                h = { ":vertical resize -2<CR>", "Window Resize Left" },
                l = { ":vertical resize +2<CR>", "Window Resize Right" },
            },
        },
    },
    ["<C-Down>"] = { ":resize +2<CR>", "which_key_ignore" },
    ["<C-Up>"] = { ":resize -2<CR>", "which_key_ignore" },
    ["<C-Right>"] = { ":vertical resize +2<CR>", "which_key_ignore" },
    ["<C-Left>"] = { ":vertical resize -2<CR>", "which_key_ignore" },
})
