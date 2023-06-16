return {
    "echasnovski/mini.jump",
    version = "*",
    config = function() require("mini.jump").setup({
        mappings = {
            repeat_jump = "",
        }
    }) end,
    lazy = false,
}
