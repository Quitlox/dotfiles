----------------------------------------------------------------------
--                              Mason                               --
----------------------------------------------------------------------
-- Mason is a tool for easily installing third-party language-servers,
-- formatters, linters, debuggers and other utilities for Neovim.
-- Mason also takes care of automatically registering language-servers to LSP
-- and tools to NullLs.

-- Require Mason
local mason_ok, mason = pcall(require, "mason")
if not mason_ok then return end
-- Require Mason-Lspconfig
local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_ok then return end
-- Require Mason-Nvim-Dap
local mason_dap_ok, mason_dap = pcall(require, "mason-nvim-dap")
if not mason_dap_ok then return end
-- Require Mason-Null-Ls
local mason_null_ls_ok, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_ok then return end

-- Setup Mason
mason.setup({
    ui = {
        border = "single",
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})
-- Setup Mason-Lspconfig
mason_lspconfig.setup({
    automatic_installation = false,
})
-- Setup Mason-Nvim-Dap
mason_dap.setup({
    automatic_setup = true,
})
mason_dap.setup_handlers()
-- Setup Mason-Null-Ls
mason_null_ls.setup({
    ensure_installed = nil,
    automatic_installation = true,
    automatic_setup = false,
})
