-- +---------------------------------------------------------+
-- | jmbuhr/otter.nvim                                       |
-- +---------------------------------------------------------+

require("otter").setup()

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "svelte" },
    group = vim.api.nvim_create_augroup("MyOtterActiviation", { clear = true }),
    desc = "Activate Otter.nvim for specific filetypes",
    callback = function()
        require("otter").activate()
    end,
})
