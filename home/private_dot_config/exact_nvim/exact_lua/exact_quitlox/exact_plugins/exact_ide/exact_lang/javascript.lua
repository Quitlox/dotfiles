return {
    {
        "folke/which-key.nvim",
        optional = true,
        opts = {
            defaults = {
                ["<localleader>n"] = { name = "Node" },
            }
        }
    },
    {
        -- package.json help
        "vuki656/package-info.nvim",
        config = true,
        dependencies = { "MunifTanjim/nui.nvim" },
        keys = {
            { "<localleader>ns", function() require("package-info").show() end,           desc = "Package Info Show",
                                                                                                                            silent = true },
            { "<localleader>nh", function() require("package-info").hide() end,           desc = "Package Info Hide",
                                                                                                                            silent = true },
            { "<localleader>nt", function() require("package-info").toggle() end,         desc = "Package Info Toggle",
                                                                                                                            silent = true },
            { "<localleader>nu", function() require("package-info").update() end,         desc = "Package Update",
                                                                                                                            silent = true },
            { "<localleader>nd", function() require("package-info").delete() end,         desc = "Package Delete",
                                                                                                                            silent = true },
            { "<localleader>nc", function() require("package-info").change_version() end, desc = "Package Change",
                                                                                                                            silent = true },
            { "<localleader>ni", function() require("package-info").install() end,        desc = "Package Install",
                                                                                                                            silent = true },
        },
    },
}
