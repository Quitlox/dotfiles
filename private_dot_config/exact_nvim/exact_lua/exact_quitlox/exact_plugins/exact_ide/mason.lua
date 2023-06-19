return {
    "williamboman/mason.nvim",
    -- TODO:
    -- keys = { "<leader>vm", function() vim.cmd[[Mason<cr>]] end, desc="Mason" },
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
