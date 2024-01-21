return {
    "mfussenegger/nvim-lint",
    config = function()
        require("lint").linters_by_ft = {
            python = { "pylint", "mypy", "codespell" },
            svelte = { "eslint_d" },
        }

        vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
            callback = function(event)
                local ft = vim.api.nvim_buf_get_option(event.buf, "filetype")

                -- Disable linting on InsertLeave for python files
                if event == "InsertLeave" and ft ~= "python" then return end

                -- Default is to lint on all events
                require("lint").try_lint(nil, { ignore_errors = true })
            end,
        })
    end,
}
