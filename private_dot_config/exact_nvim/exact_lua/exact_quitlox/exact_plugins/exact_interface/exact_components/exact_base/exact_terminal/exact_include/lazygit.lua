----------------------------------------------------------------------
--                        Terminal: Lazygit                         --
----------------------------------------------------------------------

-- Require
local terminal = require("toggleterm.terminal")
local Terminal = terminal.Terminal

-- Terminal definition
local lazygit_config = {
    id = 100,
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    on_open = function() vim.cmd("inoremap jk <Nop>") end,
}
local lazygit = Terminal:new(lazygit_config)

-- Make Lazygit follow the current working directory set by Neovim
local cur_cwd = vim.fn.getcwd()
function _G.lazygit_toggle()
    local cwd = vim.fn.getcwd()
    if cwd ~= cur_cwd then
        cur_cwd = cwd
        lazygit:close()
        lazygit = Terminal:new(lazygit_config)
    end

    lazygit:toggle()
end
