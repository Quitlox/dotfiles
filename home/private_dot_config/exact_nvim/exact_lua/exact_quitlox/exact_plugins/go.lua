-- +---------------------------------------------------------+
-- | ray-x/go.nvim: Go Support                               |
-- +---------------------------------------------------------+

-- Setup
require("go").setup({
    lsp_cfg = {},
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("MyGoLspAttach", { clear = true }),
    callback = function(args)
        local bufnr = args.bufnr
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name ~= "gopls" then
            return
        end

        -- Override the default annotation keymap
        vim.keymap.set("n", "<Leader>gca", require("go.comment").gen, { noremap = true, silent = true, desc = "Generate Annotation", buffer = bufnr })
    end,
})

-- Install the required dependencies
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    group = vim.api.nvim_create_augroup("MyGoInstall", { clear = true }),
    callback = function()
        require("go.install").install()
    end,
})
