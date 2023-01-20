local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then return end

----------------------------------------
-- Settings
----------------------------------------

toggleterm.setup({
    open_mapping = [[`]],
    -- insert_mappings=true,
    -- terminal_mappings=true,
    persist_mode=true,
    direction = "float",
    size = function(term)
        if term.direction == "horizontal" then
            return 50
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.35
        end
    end,
})

----------------------------------------
-- Keybindings
----------------------------------------

function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    -- vim.keymap.set("t", "<esc>", [[<cmd>call feedkeys("<C-\><C-n>")<cr>]], opts)
    vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end

import(
    "which-key",
    function(wk)
        wk.register({
            t = {
                name = "Terminal",
                t = { "<cmd>exe v:count1 . \"ToggleTerm size=50 direction=vertical\"<cr>", "New Terminal" },
            },
        }, { prefix = "<leader>o", silent=true })
    end
)

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

----------------------------------------------------------------------
--                            Workaround                            --
----------------------------------------------------------------------

-- Workaround for exiting neovim
-- https://github.com/neovim/neovim/issues/14061
vim.cmd([[
    command Z wa | qa
    cabbrev xa Z
]])
