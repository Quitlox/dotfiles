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

            size = function(term)
                if term.direction == "horizontal" then
                    return 50
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.35
                end
            end,
        },
    },
    init = function() require("quitlox.plugins.interface.components.base.terminal.include.keybindings") end,
}
