return {
    "echasnovski/mini.misc",
    version = "*",
    config = function(_, opts)
        require("mini.misc").setup_restore_cursor()
    end,
}
