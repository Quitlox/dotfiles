return {
    "j-morano/buffer_manager.nvim",
    init = function()
        require("which-key").register({
            b = {
                l = { "<cmd>lua require('buffer_manager.ui').toggle_quick_menu()<cr>", "Buffer List" },
            },
        }, { prefix = "<leader>" })
    end,
    config = true,
    opts = {

    }
}
