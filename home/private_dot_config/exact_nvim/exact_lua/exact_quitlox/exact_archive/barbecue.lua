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
            local status, navic = pcall(require, "nvim-navic")
            if not status then
                vim.notify("nvim-navic not found", vim.log.levels.WARN)
                return
            end

            navic.attach(client, bufnr)
        end
    end,
})

--+- Integration: Toggle ------------------------------------+
vim.g.toggle_barbecue = true
Snacks.toggle.new({
    name = "Barbecue",
    set = function(state)
        require("barbecue.ui").toggle(state)
        vim.g.toggle_barbecue = state
    end,
    get = function()
        return vim.g.toggle_barbecue
    end,
})

--+- Commands -----------------------------------------------+
require("legendary").commands({
    { ":Barbecue", description = "Barbecue" },
    { ":lua require('barbecue.ui').toggle(true)<cr>", description = "Show Barbecue" },
    { ":lua require('barbecue.ui').toggle(false)<cr>", description = "Hide Barbecue" },
    { ":lua require('barbecue.ui').toggle()<cr>", description = "Toggle Barbecue" },
})
