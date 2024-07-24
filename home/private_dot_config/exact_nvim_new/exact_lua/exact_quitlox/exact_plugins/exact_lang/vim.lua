-- +---------------------------------------------------------+
-- | jbyuki/one-small-step-for-vimkind: Vim Debugger         |
-- +---------------------------------------------------------+

-- + Debug Configuration ------------------------------------+
require("dap").configurations.lua = {
    {
        type = "nlua",
        request = "attach",
        name = "Attach to running Neovim instance",
    },
}

require("dap").adapters.nlua = function(callback, config) callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 }) end

-- + Keymaps ------------------------------------------------+
vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function() vim.keymap.set({ "n" }, "<F5>", "<cmd>lua require'osv'.launch({port = 8086})<cr>", { noremap = true }) end,
})
