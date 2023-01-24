----------------------------------------------------------------------
--                             Null LS                              --
----------------------------------------------------------------------
-- Provides third party tooling as code actions.

-- Require Null LS
local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then return end

null_ls.setup({
    -- Do not attach to C++ files (see c.lua)
    should_attach = function(bufnr) return vim.bo.filetype ~= "cpp" end,
    sources = {
        -- Lua
        null_ls.builtins.formatting.stylua,
        -- Shell
        null_ls.builtins.formatting.shfmt,
        -- Web Development
        null_ls.builtins.formatting.eslint_d,
        null_ls.builtins.formatting.prettierd.with({
            extra_filteypes = {},
        }),
        -- Python
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        -- Rust
        null_ls.builtins.formatting.trim_newlines.with({
            filetypes = { "lua", "python" }, -- use rustfmt
        }),
        null_ls.builtins.formatting.trim_whitespace.with({
            filetypes = { "lua", "python" }, -- use rustfmt
        }),
        -- LaTeX
        null_ls.builtins.diagnostics.chktex.with({
            extra_args = { "-n8", "-n1" },
        }),
        null_ls.builtins.code_actions.proselint,
        -- Json
        null_ls.builtins.diagnostics.jsonlint,
        -- Git
        null_ls.builtins.code_actions.gitsigns,
    },
})

