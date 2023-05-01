----------------------------------------------------------------------
--                        [Module] Terminal                         --
----------------------------------------------------------------------
-- Display the name of the terminal when the current buffer is a terminal.
-- Depends on the plugin "akinsho/toggleterm.nvim".

local toggleterm = {
    '%{&ft == "toggleterm" ? "terminal (".b:toggle_number.")" : ""}',
    cond = function() return vim.bo.filetype == "toggleterm" end,
}

return toggleterm
