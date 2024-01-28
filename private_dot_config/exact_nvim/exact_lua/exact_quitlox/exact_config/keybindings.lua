vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
-- vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
-- vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
-- vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
-- vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
-- vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
-- vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

----------------------------------------------------------------------
--                       Keybindings: Window                        --
----------------------------------------------------------------------

-- Close the window if it is not the current window and
-- the filetype is not equals to 'NvimTree'
local function window_only()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if win ~= vim.api.nvim_get_current_win() and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), "filetype") ~= "NvimTree" then vim.api.nvim_win_close(win, false) end
    end
end

vim.keymap.set("n", "<leader>wj", "<C-W>j", { desc = "Window Down" })
vim.keymap.set("n", "<leader>wk", "<C-W>k", { desc = "Window Up" })
vim.keymap.set("n", "<leader>wh", "<C-W>h", { desc = "Window Left" })
vim.keymap.set("n", "<leader>wl", "<C-W>l", { desc = "Window Right" })
vim.keymap.set("n", "<leader>wo", window_only, { desc = "Window Only" })
vim.keymap.set("n", "<leader>wv", "<C-W>s", { desc = "Window vSplit" })
vim.keymap.set("n", "<leader>wb", "<C-W>v", { desc = "Window Split" })
vim.keymap.set("n", "<leader>wd", "<C-W>q", { desc = "Window Delete" })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "which_key_ignore" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "which_key_ignore" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "which_key_ignore" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "which_key_ignore" })

----------------------------------------------------------------------
--                         Keybindings: Tab                         --
----------------------------------------------------------------------

vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Tab Last" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "Tab First" })
vim.keymap.set("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Tab Only" })
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "Tab New" })
vim.keymap.set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Tab Next" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Tab Close" })
vim.keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Tab Previous" })

----------------------------------------------------------------------
--                        Keybindings: Misc                         --
----------------------------------------------------------------------
-- Workaround for exiting neovim
-- https://github.com/neovim/neovim/issues/14061
vim.cmd([[
    command Z wa | qa
    cabbrev xa Z
]])
