----------------------------------------
-- Customize Toggling Behaviour
----------------------------------------
-- We use the '~' key to toggle terminals. However, the default behaviour is not
-- my style. This section customizes the behaviour to my liking.

-- When you press '~' with a count, it will create and show or hide the terminal with that id.
-- When you press '~' without a count, it will toggle all terminals.

local function create_terminal(id, direction)
    local toggleterm = require("toggleterm")

    -- Integrate python venv-selector (automatically source venv)
    local on_open = function(term)
        local venv_name = require("venv-selector").get_active_venv()
        if vim.b.custom_venv_source == nil and venv_name ~= nil then
            toggleterm.exec("source " .. venv_name .. "/bin/activate; clear", term.id)
            vim.api.nvim_set_current_win(term.window)
            vim.b.custom_venv_source = 1
        end
        vim.cmd("startinsert!")
    end

    local Terminal = require("toggleterm.terminal").Terminal
    return Terminal:new({ id = id, direction = direction, on_open = on_open })
end

vim.api.nvim_create_user_command("CustomToggleTerm", function(opts)
    local toggleterm = require("toggleterm")
    local terminal = require("toggleterm.terminal")
    local ui = require("toggleterm.ui")

    -- If there are any open terminals, close them
    if ui.find_open_windows() then
        toggleterm.toggle_all({ bang = true })
    end

    -- Toggle the terminal with the given id
    local term_id = opts.count
    local direction = term_id == 0 and "horizontal" or "float"
    local term = terminal.get(term_id) or create_terminal(term_id, direction)
    term:toggle(term_id == 0 and 18 or nil)
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

----------------------------------------
-- Plugin Configuration
----------------------------------------

return {
    "akinsho/toggleterm.nvim",
    keys = { "`" },
    config = function(_, opts)
        require("toggleterm").setup(opts)
        vim.keymap.set("n", [[`]], '<cmd>execute v:count . "CustomToggleTerm"<cr>', { silent = true })
        vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
    end,
    opts = {
        {
            persist_mode = true,
            direction = "horizontal",
            auto_scroll = false,

            -- on_open = function(term) vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true }) end,

            size = function(term)
                if term.direction == "horizontal" then
                    return 50
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.35
                end
            end,
        },
    },
    init = function()
        -- Set mapping to launch toggleterm
        vim.keymap.set("n", [[`]], '<cmd>execute v:count . "CustomToggleTerm"<cr>', { silent = true })
        -- Set mappings in toggleterm buffers
        vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
    end,
}
