----------------------------------------------------------------------
--                      Terminal: Keybindings                       --
----------------------------------------------------------------------

----------------------------------------
-- Customize Toggling Behaviour
----------------------------------------
-- We use the '~' key to toggle terminals. However, the default behaviour is not
-- my style. This section customizes the behaviour to my liking.

-- When you press '~' with a count, it will create and show or hide the terminal with that id.
-- When you press '~' without a count, it will toggle all terminals.

vim.keymap.set("n", [[`]], '<cmd>execute v:count . "CustomToggleTerm"<cr>', { silent = true })
vim.api.nvim_create_user_command("CustomToggleTerm", function(opts)
    local toggleterm = require("toggleterm")
    local terminal = require("toggleterm.terminal")
    local Terminal = terminal.Terminal

    local terminals = terminal.get_all()
    local any_terminal_visible = false
    for _, term in pairs(terminals) do
        if term:is_open() then
            any_terminal_visible = true
            break
        end
    end

    -- If a count is supplied, i.e. a specific terminal is referenced
    if opts.count ~= 0 then
        local term = terminal.get(opts.count)
        if any_terminal_visible then toggleterm.toggle_all({ bang = true }) end

        if term == nil then
            term = Terminal:new({ id = opts.count, direction = "float" }):open()
        else
            term:toggle()
        end

        return
    end

    local term0 = terminal.get(0)
    if term0 == nil then
        term0 = Terminal:new({ id = 0, direction = "horizontal" }):open(18)
    else
        if any_terminal_visible then toggleterm.toggle_all({ bang = true }) end

        term0:toggle()
    end
end, { count = true, nargs = "*" })

----------------------------------------
-- In-Terminal Keybindings
----------------------------------------

function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set("t", "`", "<cmd>ToggleTermToggleAll<cr>", opts)
    vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
