----------------------------------------------------------------------
--                             Null LS                              --
----------------------------------------------------------------------
-- Tools - Integrations with linters, formatters, etc...
-- Provides third party tooling as code actions.

return {
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = { "jay-babu/mason-null-ls.nvim" },
        config = function()
            local null_ls = require("null-ls")
            require("null-ls").setup({
                -- Do not attach to C++ files (see c.lua)
                should_attach = function(bufnr) return vim.bo.filetype ~= "cpp" end,
                sources = {
                    -- Python Sources
                    -- We do not use Mason for Python sources,
                    -- as these are best installed inside the virtual env
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.isort,
                    null_ls.builtins.formatting.autoflake,
                    null_ls.builtins.formatting.autopep8,
                    null_ls.builtins.diagnostics.pylint,
                    null_ls.builtins.diagnostics.mypy,
                    null_ls.builtins.diagnostics.flake8,
                    null_ls.builtins.diagnostics.pydocstyle,
                    null_ls.builtins.diagnostics.ruff,
                },
            })
        end,
    },
    {
        "jay-babu/mason-null-ls.nvim",
        dependencies = { "williamboman/mason.nvim" },
        version = "",
        config = true,
        opts = {
            ensure_installed = {},
            automatic_installation = false,
            handlers = {
                trim_newlines = function(source_name, methods)
                    local null_ls = require("null-ls")
                    null_ls.register(null_ls.builtins.formatting.trim_newlines.with({
                        filetypes = { "lua", "python" },
                    }))
                end,
                trim_whitespace = function(source_name, methods)
                    local null_ls = require("null-ls")
                    null_ls.register(null_ls.builtins.formatting.trim_whitespace.with({
                        filetypes = { "lua", "python" },
                    }))
                end,
                chktex = function(source_name, methods)
                    local null_ls = require("null-ls")
                    null_ls.register(null_ls.builtins.diagnostics.chktex.with({
                        extra_args = { "-n8", "-n1" },
                    }))
                end,
                -- eslint = function(source_name, methods)
                --     local null_ls = require("null-ls")
                --     null_ls.register(null_ls.builtins.formatting.prettierd.with({
                --         -- filetypes = { "javascript", "typescript", "json", "yaml", "markdown", "html", "css" },
                --         filetypes={"vue"}
                --     }))
                -- end,
                prettier = function(source_name, methods)
                    local null_ls = require("null-ls")
                    null_ls.register(null_ls.builtins.formatting.prettierd.with({
                        -- filetypes = { "javascript", "typescript", "json", "yaml", "markdown", "html", "css" },
                        filetypes = { "vue" },
                    }))
                end,
            },
        },
    },
}
