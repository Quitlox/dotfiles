return {
    "utilyre/barbecue.nvim",
    version = "*",
    dependencies = {
        "SmiteshP/nvim-navic",
        "nvim-tree/nvim-web-devicons",
    },
    init = function()
        vim.api.nvim_create_autocmd({
            "WinResized",
            "BufWinEnter",
            "CursorHold",
            "InsertLeave",
        }, {
            group = vim.api.nvim_create_augroup("barbecue.updater", {}),
            callback = function() require("barbecue.ui").update() end,
        })

        require("legendary").commands({
            { ":Barbecue", description = "Barbecue" },
            { ":lua require('barbecue.ui').toggle(true)<cr>", description = "Show Barbecue" },
            { ":lua require('barbecue.ui').toggle(false)<cr>", description = "Hide Barbecue" },
            { ":lua require('barbecue.ui').toggle()<cr>", description = "Toggle Barbecue" },
        })

        -- Register navic
        require("quitlox.util").on_attach(function(client, bufnr)
            if client.server_capabilities.documentSymbolProvider then require("nvim-navic").attach(client, bufnr) end
        end)
    end,
    opts = { attach_navic = false, create_autocmd = false },
}
