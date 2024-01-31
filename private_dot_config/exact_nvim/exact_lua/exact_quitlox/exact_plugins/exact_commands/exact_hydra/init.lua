return {
    "anuvyklack/hydra.nvim",
    lazy = true,
    keys = { "<leader>gj" },
    config = function() require("quitlox.plugins.commands.hydra.git") end,
}
