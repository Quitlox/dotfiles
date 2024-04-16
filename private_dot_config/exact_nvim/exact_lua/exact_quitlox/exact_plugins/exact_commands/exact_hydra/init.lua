return {
    "anuvyklack/hydra.nvim",
    lazy = true,
    keys = { { "<leader>gj", desc = "Stage" } },
    config = function()
        require("quitlox.plugins.commands.hydra.git")
    end,
}
