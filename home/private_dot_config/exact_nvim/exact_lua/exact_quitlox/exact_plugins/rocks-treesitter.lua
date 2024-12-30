vim.g.rocks_nvim = {
    treesitter = {
        auto_highlight = "all",
        auto_install = "prompt",
    },
}

local filetypes = { "python", "lua", "http", "typescript", "svelte" }

for _, filetype in ipairs(filetypes) do
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("MyRocksTreesitter", { clear = true }),
        desc = "Start Treesitter",
        pattern = { filetype },
        callback = function(args)
            vim.treesitter.start(args.buffer, filetype)
        end,
    })
end

require("nvim-treesitter.configs").setup({
    highlight = { enable = true },
    indent = { enable = true },
})

require("legendary").commands({
    {
        ":TreesitterStart",
        function()
            vim.treesitter.start(vim.api.nvim_get_current_buf(), vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "ft"))
        end,
        description = "Start Treesitter",
    },
    {
        ":TSConfigInfo",
        function()
            vim.treesitter.start()
        end,
        description = "Treesitter Config Info",
    },
    {
        ":TSModuleInfo",
        function()
            vim.treesitter.start()
        end,
        description = "Treesitter Module Info",
    },
    {
        ":TSInstallInfo",
        function()
            vim.treesitter.start()
        end,
        description = "Treesitter Install Info",
    },
})
