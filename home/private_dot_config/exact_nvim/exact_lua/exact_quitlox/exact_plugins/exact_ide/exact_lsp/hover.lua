return {
    "lewis6991/hover.nvim",
    keys = {
        { "gh", "<cmd>lua require('hover').hover()<cr>", desc = "Hover" },
        { "K", "<cmd>lua require('hover').hover()<cr>", desc = "Hover" },
        { "gK", "<cmd>lua require('hover').hover_select()<cr>", desc = "Hover Select" },
        -- { "<MouseMove>", "<cmd>lua require('hover').hover_mouse()<cr>", desc = "Hover Mouse" },
    },
    config = function(_, opts)
        require("hover").setup({
            init = function()
                -- Require providers
                require("hover.providers.lsp")
                require("hover.providers.dap")
                require("hover.providers.man")
            end,
        })
    end,
    init = function()
        vim.o.mousemoveevent = true
    end,
}
