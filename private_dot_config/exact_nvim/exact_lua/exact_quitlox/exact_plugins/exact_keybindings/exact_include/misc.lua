----------------------------------------------------------------------
--                        Keybindings: Misc                         --
----------------------------------------------------------------------

----------------------------------------------------------------------
--                            Workaround                            --
----------------------------------------------------------------------

-- Workaround for exiting neovim
-- https://github.com/neovim/neovim/issues/14061
vim.cmd([[
    command Z wa | qa
    cabbrev xa Z
]])

