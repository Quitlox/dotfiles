----------------------------------------------------------------------
--                             Null LS                              --
----------------------------------------------------------------------
-- Tools - Integrations with linters, formatters, etc...
-- Provides third party tooling as code actions.

return {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
        local null_ls = require("null-ls")
        require("null-ls").setup({
            debug=true,
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
                -- Typescript
                require("typescript.extensions.null-ls.code-actions"),
                -- Python
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.isort,
                null_ls.builtins.diagnostics.mypy,
                null_ls.builtins.diagnostics.pylint,
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
    end,
}
