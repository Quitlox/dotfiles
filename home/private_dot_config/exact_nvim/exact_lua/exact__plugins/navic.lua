-- +---------------------------------------------------------+
-- | nvim-navic: Winbar component for Treesitter Context     |
-- +---------------------------------------------------------+

-- TODO: Filter, requires: https://github.com/SmiteshP/nvim-navic/pull/134/files

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

require("nvim-navic").setup({
    icons = require("_config.util.codicons").kinds,
    highlight = true,
    separator = " > ",
    depth_limit = 0,
    depth_limit_indicator = "..",
    lazy_update_context = false,
})
