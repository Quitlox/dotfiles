return {
    "akinsho/toggleterm.nvim",
    -- TODO: "`" break the key
   -- keys = { "`", "<leader>ogl", "<leader>ot" },
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
        require("quitlox.plugins.ui.components.terminal.include.lazygit")
    end,

    init = function()
        require("quitlox.plugins.ui.components.terminal.include.keybindings")
    end,
}
