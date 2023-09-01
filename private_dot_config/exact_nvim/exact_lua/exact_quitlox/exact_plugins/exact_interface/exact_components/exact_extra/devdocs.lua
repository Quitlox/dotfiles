return {
    {
        "luckasRanarison/nvim-devdocs",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            previewer_cmd = "glow",
            cmd_args = { "-s", "dark", "-w", "80" },
        },
        cmd = {
            "DevdocsFetch",
            "DevdocsInstall",
            "DevdocsUninstall",
            "DevdocsOpen",
            "DevdocsOpenFloat",
            "DevdocsOpenCurrent",
            "DevdocsOpenCurrentFloat",
            "DevdocsUpdate",
            "DevdocsUpdateAll",
        },
        keys = {
            { "<leader>md", "<cmd>DevdocsOpenFloat<cr>", desc = "Devdocs" },
        },
    },
    {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = function(_, opts)
            opts.commands = opts.commands or {}
            vim.list_extend(opts.commands, {
                { "DevdocsFetch", description = "Fetch DevDocs metadata." },
                { "DevdocsInstall", description = "Install documentation, 0-n args." },
                { "DevdocsUninstall", description = "Uninstall documentation, 0-n args." },
                { "DevdocsOpen", description = "Open documentation in a normal buffer, 0 or 1 arg." },
                { "DevdocsOpenFloat", description = "Open documentation in a floating window, 0 or 1 arg." },
                {
                    "DevdocsOpenCurrent",
                    description = "Open documentation for the current filetype in a normal buffer.",
                },
                {
                    "DevdocsOpenCurrentFloat",
                    description = "Open documentation for the current filetype in a floating window.",
                },
                { "DevdocsUpdate", description = "Update documentation, 0-n args." },
                { "DevdocsUpdateAll", description = "Update all documentations." },
            })
        end,
    },
}
