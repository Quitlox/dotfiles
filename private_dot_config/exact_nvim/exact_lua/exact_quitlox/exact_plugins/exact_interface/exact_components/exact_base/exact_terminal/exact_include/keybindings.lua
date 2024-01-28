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

    -- Integrate python venv-selector (automatically source venv)
    local cmd = ""
    local venv_name = require("venv-selector").get_active_venv()
    if venv_name ~= nil then cmd = "source " .. venv_name .. "/bin/activate; clear" end
    local on_open = function(term)
        if vim.b.custom_venv_source == nil then
            require("toggleterm").exec(cmd, term.id)
            vim.api.nvim_set_current_win(term.window)
            vim.b.custom_venv_source = 1
        end
        vim.cmd("startinsert!")
    end

    -- If a count is supplied, i.e. a specific terminal is referenced
    if opts.count ~= 0 then
        local term = terminal.get(opts.count)
        if any_terminal_visible then toggleterm.toggle_all({ bang = true }) end

        if term == nil then
            term = Terminal:new({ id = opts.count, direction = "float", on_open = on_open }):open()
        else
            term:toggle()
        end

        return
    end

    local term0 = terminal.get(0)
    if term0 == nil then
        term0 = Terminal:new({ id = 0, direction = "horizontal", on_open = on_open }):open(18)
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
    vim.keymap.set("n", "q", "<cmd>close<cr>", opts)
    vim.keymap.set("n", "<esc>", "<cmd>close<cr>", opts)
    vim.keymap.set("t", "`", "<cmd>ToggleTermToggleAll<cr>", opts)
    vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
