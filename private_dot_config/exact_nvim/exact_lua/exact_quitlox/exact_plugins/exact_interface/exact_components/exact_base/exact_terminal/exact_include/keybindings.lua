----------------------------------------------------------------------
--                      Terminal: Keybindings                       --
----------------------------------------------------------------------

----------------------------------------
-- Customize Toggling Behaviour
----------------------------------------
-- We use the '~' key to toggle terminals. However, the default behaviour is not
-- my style. This section customizes the behaviour to my liking.

-- When you press '~' with a count, it will create or destroy the terminal with that id.
-- When you press '~' without a count, it will toggle all terminals.

vim.keymap.set("n", [[`]], '<cmd>execute v:count . "CustomToggleTerm"<cr>', { silent = true })
vim.api.nvim_create_user_command("CustomToggleTerm", function(opts)
    local toggleterm = require("toggleterm")
    local terminal = require("toggleterm.terminal")
    local Terminal = terminal.Terminal

    -- If a count is supplied, i.e. a specific terminal is referenced
    if opts.count ~= 0 then
        local term = terminal.get(opts.count)
        if term == nil then
            -- Create it if it doesn't exist yet
            toggleterm.toggle_all({ bang = true })
            Terminal:new({ id = opts.count }):open()
        else
            -- Open it if it does exist
            term:toggle()
        end

        return
    end

    -- If no count is supplied, all terminals should be toggled
    local terminals = terminal.get_all()
    if #terminals == 0 then
        -- If there currently exist no terminals
        -- Create a Default Terminal to toggle
        Terminal:new({ id = 1, direction = "horizontal" }):open(18)
    else
        toggleterm.toggle_all({ bang = true })
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
