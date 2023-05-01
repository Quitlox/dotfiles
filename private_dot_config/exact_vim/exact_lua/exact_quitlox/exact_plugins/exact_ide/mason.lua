return {
    "williamboman/mason.nvim",
    config = true,
    opts = {
        ui = {
            border = "single",
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
            },
        },
        keymaps = {
            uninstall_package = "x",
            toggle_package_expand = "<tab>",
        }
    },
    init = function()
        require("which-key").register({
            m = { "<cmd>Mason<cr>", "Mason" },
        }, { prefix = "<leader>v" })
    end,
}
