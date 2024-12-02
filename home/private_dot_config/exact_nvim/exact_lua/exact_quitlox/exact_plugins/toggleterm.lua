--+- Customize Toggling Behaviour ---------------------------+
-- We use the '~' key to toggle terminals. However, the default behaviour is not
-- my style. This section customizes the behaviour to my liking.

-- When you press '~' with a count, it will create and show or hide the terminal with that id.
-- When you press '~' without a count, it will toggle all terminals.

local function create_terminal(id, direction)
    local on_open = function(term) vim.cmd("startinsert!") end
    local Terminal = require("toggleterm.terminal").Terminal
    return Terminal:new({ id = id, direction = direction, on_open = on_open })
end

vim.api.nvim_create_user_command("CustomToggleTerm", function(opts)
    local toggleterm = require("toggleterm")
    local terminal = require("toggleterm.terminal")
    local ui = require("toggleterm.ui")

    -- If there are any open terminals, close them
    if ui.find_open_windows() then toggleterm.toggle_all({ bang = true }) end

    -- Toggle the terminal with the given id
    local term_id = opts.count
    local direction = term_id == 0 and "horizontal" or "float"
    local term = terminal.get(term_id) or create_terminal(term_id, direction)
    term:toggle(term_id == 0 and 18 or nil)
end, { count = true, nargs = "*" })

--+- Keymaps ------------------------------------------------+
function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set("n", "q", "<cmd>close<cr>", opts)
    vim.keymap.set("n", "<esc>", "<cmd>close<cr>", opts)

    vim.keymap.set("t", "`", "<cmd>ToggleTermToggleAll<cr>", opts)
    vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
end

-- Set mapping to launch toggleterm
vim.keymap.set("n", [[`]], '<cmd>execute v:count . "CustomToggleTerm"<cr>', { silent = true })
vim.keymap.set("v", [[`]], '<Esc><cmd>execute v:count . "CustomToggleTerm"<cr>', { silent = true })
-- Set mappings in toggleterm buffers
vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")

--+- Setup --------------------------------------------------+
require("toggleterm").setup({
    direction = "horizontal",
    auto_scroll = true,
})
