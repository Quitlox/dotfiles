-- +---------------------------------------------------------+
-- | mfussenegger/nvim-lint: Linting                         |
-- +---------------------------------------------------------+

require("lint").linters_by_ft = {
    python = { "pylint", "mypy", "codespell" },
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
    svelte = { "eslint_d" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
    callback = function(event)
        local ft = vim.api.nvim_buf_get_option(event.buf, "filetype")

        -- Disable linting on InsertLeave for python files due to slow performance
        if event == "InsertLeave" and ft ~= "python" then return end
        -- Default is to lint on all events
        require("lint").try_lint(nil, { ignore_errors = true })
    end,
})

local lint_progress = function()
    local linters = require("lint").get_running()
    if #linters == 0 then return "󰦕" end

    return "󱉶 " .. table.concat(linters, ", ")
end
