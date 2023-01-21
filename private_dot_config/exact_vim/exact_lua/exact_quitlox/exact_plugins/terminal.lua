-- Import ToggleTerm
local toggleterm_ok, toggleterm = pcall(require, "toggleterm")
if not toggleterm_ok then return end
-- Import WhichKey
local which_key_ok, wk = pcall(require, "which-key")
if not which_key_ok then return end

----------------------------------------
-- Settings
----------------------------------------

local preferred_direction = "horizontal"

toggleterm.setup({
    -- insert_mappings=true,
    -- terminal_mappings=true,
    persist_mode = true,
    direction = preferred_direction,
    size = function(term)
        if term.direction == "horizontal" then
            return 50
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.35
        end
    end,
})

----------------------------------------
-- Customize Toggling Behaviour
----------------------------------------

local Terminal = require("toggleterm.terminal").Terminal
local terminal = require("toggleterm.terminal")

vim.keymap.set("n", [[`]], '<cmd>execute v:count . "CustomToggleTerm"<cr>', { silent = true })
vim.api.nvim_create_user_command("CustomToggleTerm", function(opts)
    -- If a count is supplied, i.e. a specific terminal is referenced
    if opts.count ~= 0 then
        local term = terminal.get(opts.count)
        if term == nil then
            -- Create it if it doesn't exist yet
            toggleterm.toggle_all({bang=true})
            Terminal:new({id = opts.count}):open()
        else
            -- Destory it if it does
            term:shutdown()
        end

        return
    end

    -- If no count is supplied, all terminals should be toggled
    local terminals = terminal.get_all()
    if #terminals == 0 then
        -- If there currently exist no terminals
        -- Create a Default Terminal to toggle
        Terminal:new({ id = 1, direction = preferred_direction }):open(18)
    else
        toggleterm.toggle_all({ bang = true })
    end
end, { count = true, nargs = "*" })

----------------------------------------
-- Keybindings
----------------------------------------

function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    -- vim.keymap.set("t", "jk", [[<cmd>call feedkeys("<C-\><C-n>")<cr>]], opts)
    vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
    -- vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
    -- vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
    -- vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
    -- vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end

-- Lazygit
local lazygit_config = {
    id = 100,
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    on_open = function() vim.cmd("inoremap jk <Nop>") end,
}
local lazygit = Terminal:new(lazygit_config)
local cur_cwd = vim.fn.getcwd()
local function lazygit_toggle()
    -- Make Lazygit follow the CWD of Neovim
    local cwd = vim.fn.getcwd()
    if cwd ~= cur_cwd then
        cur_cwd = cwd
        lazygit:close()
        lazygit = Terminal:new(lazygit_config)
    end

    lazygit:toggle()
end

wk.register({
    g = {
        l = { lazygit_toggle, "Open Lazygit" },
    },
    o = {
        t = {
            name = "Terminal",
            h = { '<cmd>exe v:count1 . "ToggleTerm size=18 direction=horizontal"<cr>', "Open Terminal Horizontal" },
            v = { '<cmd>exe v:count1 . "ToggleTerm size=50 direction=vertical"<cr>', "Open Terminal Vertical" },
            f = { '<cmd>exe v:count1 . "ToggleTerm direction=float"<cr>', "Open Terminal Floating" },
            t = { '<cmd>exe v:count1 . "ToggleTerm direction=tab"<cr>', "Open Terminal Tab" },
        },
    },
}, { prefix = "<leader>", silent = true })

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")

----------------------------------------------------------------------
--                            Workaround                            --
----------------------------------------------------------------------

-- Workaround for exiting neovim
-- https://github.com/neovim/neovim/issues/14061
vim.cmd([[
    command Z wa | qa
    cabbrev xa Z
]])

wk.register({ q = { "<cmd>wa | qa<cr>", "Quit" } }, { prefix = "<leader>" })
