return {
    "kevinhwang91/nvim-hlslens",
    config = true,
    enabled = false,
    version = "",
    keys = {
        -- stylua: ignore start
        { "n", "<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>", silent = true, desc = "which_key_ignore" },
        { "N", "<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>", silent = true, desc = "which_key_ignore" },
        { "*", "*<cmd>lua require('hlslens').start()<cr>", silent = true, desc = "which_key_ignore" },
        { "#", "#<cmd>lua require('hlslens').start()<cr>", silent = true, desc = "which_key_ignore" },
        { "g*", "g*<cmd>lua require('hlslens').start()<cr>", silent = true, desc = "which_key_ignore" },
        { "g#", "g#<cmd>lua require('hlslens').start()<cr>", silent = true, desc = "which_key_ignore" },
        -- stylua: ignore end
    },
}
