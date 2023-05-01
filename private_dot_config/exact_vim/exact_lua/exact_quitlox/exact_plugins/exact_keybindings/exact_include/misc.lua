----------------------------------------------------------------------
--                        Keybindings: Misc                         --
----------------------------------------------------------------------

require("which-key").register({
    ["<leader>"] = {
        s = { ":wa<cr>", "Save" },
    },
})

----------------------------------------------------------------------
--                            Workaround                            --
----------------------------------------------------------------------

-- Workaround for exiting neovim
-- https://github.com/neovim/neovim/issues/14061
vim.cmd([[
    command Z wa | qa
    cabbrev xa Z
]])

require("which-key").register({ q = { "<cmd>wa | qa<cr>", "Quit" } }, { prefix = "<leader>" })
