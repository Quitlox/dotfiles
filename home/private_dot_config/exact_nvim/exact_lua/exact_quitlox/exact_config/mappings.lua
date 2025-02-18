-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Save
vim.keymap.set({ "n", "i" }, "<C-s>", "<cmd>w<CR>")
vim.keymap.set({ "n", "i" }, "<C-S>", "<cmd>wa<CR>")

-- Delete Word
vim.keymap.set("i", "<C-BS>", "<C-w>")
vim.keymap.set("i", "<C-h>", "<C-w>")
vim.keymap.set("c", "<C-BS>", "<C-w>")
vim.keymap.set("c", "<C-h>", "<C-w>")

-- Delete Word
vim.keymap.set("i", "<C-BS>", "<C-w>", { noremap = true })
vim.keymap.set("i", "<C-h>", "<C-w>", { noremap = true })
vim.keymap.set("c", "<C-BS>", "<C-w>", { noremap = true })
vim.keymap.set("c", "<C-h>", "<C-w>", { noremap = true })

-- Disable defaults
vim.keymap.set("n", "<C-w>d", "<nop>")
vim.keymap.set("n", "<C-w><C-d>", "<nop>")

-- +---------------------------------------------------------+
-- | Vim Editing                                             |
-- +---------------------------------------------------------+

-- Disable { and } because I keep abusing them
-- vim.keymap.set("n", "{", "", { noremap = true })
-- vim.keymap.set("n", "}", "", { noremap = true })

-- Make paste reselect yank
vim.keymap.set("x", "p", "pgvy", { noremap = true })

-- Ensure cursor stays in place when janking selection
vim.keymap.set("v", "y", "ygv<Esc>", { noremap = true })

-- Keep cursor centered when jumping
vim.keymap.set("n", "n", "nzzzv", { noremap = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true })
vim.keymap.set("n", "J", "mzJ`z", { noremap = true })

-- Navigating with soft wrapping and other common navigations
vim.keymap.set({ "n", "x" }, "j", "gj", { noremap = true })
vim.keymap.set({ "n", "x" }, "gj", "j", { noremap = true })
vim.keymap.set({ "n", "x" }, "k", "gk", { noremap = true })
vim.keymap.set({ "n", "x" }, "gk", "k", { noremap = true })

-- Undo breakpoints
vim.keymap.set("i", ",", ",<c-g>u", { noremap = true })
vim.keymap.set("i", ".", ".<c-g>u", { noremap = true })
vim.keymap.set("i", "!", "!<c-g>u", { noremap = true })
vim.keymap.set("i", "?", "?<c-g>u", { noremap = true })

-- Re-select blocks after indenting in visual/select mode
vim.keymap.set("x", "<", "<gv", { noremap = true })
vim.keymap.set("x", ">", ">gv", { noremap = true })
vim.keymap.set("v", "=", "=gv", { noremap = true })

-- Disable highlight when <leader><cr> is pressed
vim.keymap.set("n", "<leader><cr>", ":noh<cr>", { silent = true })

-- Enter command mode from visual mode
vim.keymap.set("v", ":", ":<C-U>", { noremap = true })

-- +---------------------------------------------------------+
-- | Window                                                  |
-- +---------------------------------------------------------+

-- Window navigations
vim.keymap.set({ "n", "v" }, "<C-h>", "<C-w>h")
vim.keymap.set({ "n", "v" }, "<C-j>", "<C-w>j")
vim.keymap.set({ "n", "v" }, "<C-k>", "<C-w>k")
vim.keymap.set({ "n", "v" }, "<C-l>", "<C-w>l")

-- Close the window if it is not the current window and
-- the filetype is not equals to 'NvimTree'
local function window_only()
    local tabpage = vim.api.nvim_get_current_tabpage()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
        if win ~= vim.api.nvim_get_current_win() and vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, false)
        end
    end
end

vim.keymap.set("n", "<leader>wo", window_only, { desc = "Window Only" })
vim.keymap.set("n", "<leader>wv", "<C-W>s", { desc = "Window vSplit" })
vim.keymap.set("n", "<leader>wb", "<C-W>v", { desc = "Window Split" })
vim.keymap.set("n", "<leader>wd", "<C-W>q", { desc = "Window Delete" })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "which_key_ignore" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "which_key_ignore" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "which_key_ignore" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "which_key_ignore" })

-- +---------------------------------------------------------+
-- | Buffers                                                 |
-- +---------------------------------------------------------+

--+- Function: Close Other Buffers --------------------------+
local function close_all_but_current()
    local current = vim.api.nvim_get_current_buf()
    for _, bufnr in pairs(vim.api.nvim_list_bufs()) do
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

        pcall(vim.cmd, string.format("bd %d", bufnr))

        ::continue::
    end
end

local function close_all_but_current_force()
    local current = vim.api.nvim_get_current_buf()
    for _, bufnr in pairs(vim.api.nvim_list_bufs()) do
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

        pcall(vim.cmd, string.format("bw! %d", bufnr))

        ::continue::
    end
end

-- stylua: ignore start
vim.keymap.set("n", "<leader>bd", function() require('snacks').bufdelete() end, { desc = "Buffer Delete" })
vim.keymap.set("n", "<leader>bo", close_all_but_current, { desc = "Buffer Only" })
vim.keymap.set("n", "<leader>bw", close_all_but_current_force, { desc = "Buffer Only (Force)" })
-- stylua: ignore end

-- +---------------------------------------------------------+
-- | Tab                                                     |
-- +---------------------------------------------------------+

vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Tab Last" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "Tab First" })
vim.keymap.set("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Tab Only" })
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "Tab New" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Tab Close" })

vim.keymap.set("n", "[<tab>", "<cmd>tabprevious<cr>", { desc = "Tab Previous" })
vim.keymap.set("n", "]<tab>", "<cmd>tabnext<cr>", { desc = "Tab Next" })

-- +---------------------------------------------------------+
-- | Command Mode                                            |
-- +---------------------------------------------------------+

-- Command mode mappings:
vim.keymap.set("x", "<C-A>", "<Home>")
vim.keymap.set("x", "<C-E>", "<End>")
vim.keymap.set("x", "<C-K>", "<C-U>")
vim.keymap.set("x", "<C-P>", "<Up>")
vim.keymap.set("x", "<C-N>", "<Down>")

-- +---------------------------------------------------------+
-- | Miscellaneous                                           |
-- +---------------------------------------------------------+

-- Workaround for exiting neovim
-- https://github.com/neovim/neovim/issues/14061
vim.cmd([[
    command Z wa | qa
    cabbrev xa Z
]])

-- Copy error message
vim.keymap.set("n", "<leader>vm", "<cmd>let @*=trim(execute('1messages'))<CR><cmd>echo 'copied'<CR>", { desc = "Copy Messages" })
