return {
    "akinsho/toggleterm.nvim",
    -- TODO: "`" break the key
   -- keys = { "`", "<leader>ogl", "<leader>ot" },
    opts = {
        {
            persist_mode = true,
            direction = "horizontal",

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

        require("which-key").register({
            g = {
                -- TODO: Does this work?
                l = { lazygit_toggle, "Git Lazy" },
            },
            t = {
                name = "Terminal",
                h = { '<cmd>exe v:count1 . "ToggleTerm size=18 direction=horizontal"<cr>', "Open Terminal Horizontal" },
                v = { '<cmd>exe v:count1 . "ToggleTerm size=50 direction=vertical"<cr>', "Open Terminal Vertical" },
                f = { '<cmd>exe v:count1 . "ToggleTerm direction=float"<cr>', "Open Terminal Floating" },
                t = { '<cmd>exe v:count1 . "ToggleTerm direction=tab"<cr>', "Open Terminal Tab" },
            },
        }, { prefix = "<leader>o" })
    end,
}
