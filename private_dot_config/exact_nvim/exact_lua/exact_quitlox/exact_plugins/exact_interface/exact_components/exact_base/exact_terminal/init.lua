return {
    "akinsho/toggleterm.nvim",
    lazy = false,
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
    config = function(_, opts)
        require("toggleterm").setup(opts)
        require("quitlox.plugins.interface.components.base.terminal.include.lazygit")
    end,
    init = function() require("quitlox.plugins.interface.components.base.terminal.include.keybindings") end,
}
