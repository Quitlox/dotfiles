-- +---------------------------------------------------------+
-- | utilyre/barbecue.nvim: Breadcrumbs                      |
-- +---------------------------------------------------------+

--+- Setup --------------------------------------------------+
require("barbecue").setup({
    attach_navic = false,
    create_autocmd = false,
    theme = "catppuccin",
})

vim.api.nvim_create_autocmd({ "WinResized", "BufWinEnter", "CursorHold", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("MyBarbecueUpdate", { clear = true }),
    callback = function()
        require("barbecue.ui").update()
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("MyBarbecueAttach", { clear = true }),
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end
        if client.server_capabilities.documentSymbolProvider then
            require("nvim-navic").attach(client, bufnr)
        end
    end,
})

--+- Commands -----------------------------------------------+
require("legendary").commands({
    { ":Barbecue", description = "Barbecue" },
    { ":lua require('barbecue.ui').toggle(true)<cr>", description = "Show Barbecue" },
    { ":lua require('barbecue.ui').toggle(false)<cr>", description = "Hide Barbecue" },
    { ":lua require('barbecue.ui').toggle()<cr>", description = "Toggle Barbecue" },
})
