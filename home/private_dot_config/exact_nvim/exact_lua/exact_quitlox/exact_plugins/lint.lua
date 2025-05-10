-- +---------------------------------------------------------+
-- | mfussenegger/nvim-lint: Linting                         |
-- +---------------------------------------------------------+

require("lint").linters_by_ft = {
    -- Major Languages
    python = { "pylint", "mypy", "codespell" },
    rust = { "clippy", "codespell" },

    -- Web Development
    javascript = { "eslint_d", "codespell" },
    typescript = { "eslint_d", "codespell" },
    svelte = { "eslint_d", "codespell" },

    -- Minor Languages
    ansible = { "ansible_lint", "codespell" },
    bash = { "shellcheck", "codespell" },
}

--+- Auto Save ----------------------------------------------+
vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("MyLintOnAutoSave", { clear = true }),
    callback = function(event)
        local ft = vim.api.nvim_get_option_value("filetype", { buf = event.buf })

        -- Performance: Disable linting on InsertLeave for python files due to slow performance
        if event == "InsertLeave" and ft ~= "python" then
            return
        end

        -- Default is to lint on all events
        require("lint").try_lint(nil, { ignore_errors = true })
    end,
})

--+- Support: Check Installation Status ------------------------+
local blacklist = { "pylint", "mypy" }
local checked_filetypes = {}

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("MyLintCheckInstallation", { clear = true }),
    callback = function(event)
        local lint = require("lint")
        local ft = vim.bo[event.buf].filetype

        -- Skip if we've already checked this filetype
        if checked_filetypes[ft] then
            return
        end

        -- Mark this filetype as checked
        checked_filetypes[ft] = true

        if not lint.linters_by_ft[ft] then
            return
        end

        local missing_linters = {}
        for _, linter_name in ipairs(lint.linters_by_ft[ft]) do
            if not vim.tbl_contains(blacklist, linter_name) then
                local linter = lint.linters[linter_name]

                -- Some linters may be functions that need to be called
                if type(linter) == "function" then
                    linter = linter()
                end

                -- If linter exists and has a command
                if linter and linter.cmd then
                    if vim.fn.executable(linter.cmd) == 0 then
                        table.insert(missing_linters, { name = linter_name, cmd = linter.cmd })
                    end
                end
            end
        end

        -- Notify user about missing linters
        if #missing_linters > 0 then
            local message = "Missing linters for " .. ft .. ":\n"
            for _, linter in ipairs(missing_linters) do
                message = message .. "  - " .. linter.name .. ": " .. linter.cmd .. "\n"
            end
            vim.notify(message, vim.log.levels.WARN)
        end
    end,
})
