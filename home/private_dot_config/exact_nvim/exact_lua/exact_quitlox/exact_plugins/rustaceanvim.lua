--+- Check Requirements -------------------------------------+
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("MyRustRequirementsCheck", { clear = true }),
    desc = "Check requirements for rust coding",
    pattern = "rust",
    once = true,
    callback = function()
        if not vim.fn.executable("lldb-dap") then vim.notify('Debugger "lldb-dap" not found!', vim.log.levels.WARN) end
    end,
})

-- FIXME: Currently required due to cmp-nvim-lsp not supporting a specific feature of rust-analyzer.
-- Remove once issue below is resolved
-- https://github.com/hrsh7th/cmp-nvim-lsp/issues/72
vim.g.rustaceanvim = {
    server = {
        capabilities = vim.lsp.protocol.make_client_capabilities(),
    },
}

vim.keymap.set("n", "<localleader>rp", "<cmd>RustLsp parentModule<cr>", { desc = "Open Parent" })
vim.keymap.set("n", "<localleader>rd", "<cmd>RustLsp openDocs<cr>", { desc = "Open Docs" })
vim.keymap.set("n", "<localleader>rc", "<cmd>RustLsp openCargo<cr>", { desc = "Open Cargo" })
vim.keymap.set("n", "<localleader>re", "<cmd>RustLsp explainError<cr>", { desc = "Open Explain Error" })
vim.keymap.set("n", "<localleader>rr", "<cmd>RustLsp run<cr>", { desc = "Open Run" })

require("which-key").add({
    { "<localleader>r", group = "Rust", icon = "󱘗" },
})