return {
    "williamboman/mason.nvim",
    keys = { { "<leader>vm", "<cmd>Mason<cr>", desc = "Mason" } },
    version = "",
    lazy = false,
    opts = {
        ui = {
            border = "single",
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
            },
            keymaps = {
                uninstall_package = "x",
                toggle_package_expand = "<tab>",
            },
        },
    },
}
