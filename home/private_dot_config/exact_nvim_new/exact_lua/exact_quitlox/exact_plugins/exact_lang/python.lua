--+- LSP ----------------------------------------------------+
---@diagnostic disable-next-line: missing-fields
require("lspconfig").pyright.setup({
    on_attach = function(client, bufnr)
        local function filter_diagnostics(diagnostic)
            if diagnostic.source ~= "Pyright" then return true end

            -- Just disable 'is not accessed' altogether
            if string.match(diagnostic.message, '".+" is not accessed') then return false end
            return true
        end

        local function custom_on_publish_diagnostics(a, params, client_id, c, config)
            require("quitlox.util.misc").filter(params.diagnostics, filter_diagnostics)
            vim.lsp.diagnostic.on_publish_diagnostics(a, params, client_id, c, config)
        end

        client.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(custom_on_publish_diagnostics, {})
    end,
    capabilities = require("quitlox.util.lsp").capabilities,
})

-- +---------------------------------------------------------+
-- | linux-cultist/venv-selector.nvim: Virtual Environment   |
-- +---------------------------------------------------------+

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "python",
    callback = function() require("venv-selector").setup({}) end,
})

--+- Commands -----------------------------------------------+
require("legendary").commands({
    { ":VenvSelector", description = "Select Virtual Env", filters = { ft = { "python" } } },
    { ":VenvDeactivate", ":lua require('venv-selector').deactivate()<cr>", description = "Deactivate Virtual Env", filters = { ft = { "python" } } },
})

-- +---------------------------------------------------------+
-- | mfussenegger/nvim-dap-python: Python Debug Adapter      |
-- +---------------------------------------------------------+

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "python",
    callback = function()
        local pythondap = require("dap-python")
        local bufnr = vim.api.nvim_get_current_buf()

        -- Use available python interpreter (either venv or system python)
        pythondap.setup("python")
        -- Set pytest as default test runner
        pythondap.rest_runner = "pytest"

        -- Set keymaps specifically for python
        vim.keymap.set("n", "<leader>dy", pythondap.test_method, { buffer = bufnr, desc = "Debug Method" })
        vim.keymap.set("v", "<leader>ds", pythondap.debug_selection, { buffer = bufnr, desc = "Debug Selection" })

        -- Install debugpy
        -- TODO: Check if this works
        InstallPackageInVenv("debugpy")
    end,
})

--+- Helper functions ---------------------------------------+
function InstallPackageInVenv(name)
    -- Determine if running inside a virtual environment
    local venv_path = vim.fn.getenv("VIRTUAL_ENV")

    -- Check if running in a virtual environment
    if venv_path and venv_path ~= "" then
        -- Attempt to install package using pip
        local handle = io.popen(venv_path .. "/bin/pip install " .. name)
        if not handle then
            vim.notify("Failed to install '" .. name .. "' into the virtual environment '" .. venv_path .. "'.", vim.log.levels.ERROR, { title = "Python Support" })
            return
        end

        local result = handle:read("*a")
        local success = handle:close()

        if success then
            vim.notify("Black formatter installed successfully.", vim.log.levels.INFO, { title = "Python Support" })
        else
            vim.notify("Failed to install Black formatter.", vim.log.levels.ERROR, { title = "Python Support" })
        end
    else
        -- Not running inside a virtual environment
        if pcall(require, "notify") then
            require("notify")("Not running inside a virtual environment.", "warn", { title = "Python Support" })
        else
            vim.api.nvim_out_write("Not running inside a virtual environment.\n")
        end
    end
end
