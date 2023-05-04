return {
    -- package.json help 
    "vuki656/package-info.nvim",
    config = true,
    dependencies = {"MunifTanjim/nui.nvim"},
    init = function()
        require("which-key").register({
            name = "Node",
            s = { "<cmd>lua require('package-info').show()<cr>", "Package Info Show" },
            h = { "<cmd>lua require('package-info').hide()<cr>", "Package Info Hide" },
            t = { "<cmd>lua require('package-info').toggle()<cr>", "Package Info Toggle" },
            u = { "<cmd>lua require('package-info').update()<cr>", "Package Update" },
            d = { "<cmd>lua require('package-info').delete()<cr>", "Package Delete" },
            c = { "<cmd>lua require('package-info').change_version()<cr>", "Package Change" },
            i = { "<cmd>lua require('package-info').install()<cr>", "Package Install" },
        }, { prefix = "<localleader>n", silent=true, noremap=true})
    end,
    -- import cost
    {
        "barrett-ruth/import-cost.nvim",
        build = "sh install.sh yarn",
        ft = "js,ts,tsx,jsx",
        config = true,
    },
}
