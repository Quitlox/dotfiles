-- NOTE: Remove this file, no longer used

local M = {}

local function has_uv(venv_path)
    local file_path = venv_path .. "/pyvenv.cfg"
    local file = io.open(file_path, "r")
    if not file then
        return false, "Unable to open " .. file_path
    end

    for line in file:lines() do
        if line:find("uv") then
            file:close()
            return true
        end
    end

    file:close()
    return false
end

M.install_package_in_venv = function(name, on_success)
    local venv_path = vim.fn.getenv("VIRTUAL_ENV")

    -- Check if running in a virtual environment
    if venv_path == vim.v.null or venv_path == "" then
        return
    end

    local uv_present = false
    local ok, err = pcall(function()
        uv_present = has_uv(venv_path)
    end)

    if not ok then
        return vim.notify("Error reading 'pyvenv.cfg': " .. err, vim.log.levels.ERROR, { title = "Python Support" })
    end

    local handle = require("fidget.progress").handle.create({
        title = name,
        message = "Installing...",
        lsp_client = { name = "python-support" },
    })

    local function check_if_installed(callback)
        local python_command = (uv_present and "uv pip show " or venv_path .. "/bin/python -m pip show ") .. name
        vim.uv.spawn("/bin/sh", {
            args = { "-c", python_command },
        }, function(code, signal)
            callback(code)
        end)
    end

    local function install_package()
        local install_command = (uv_present and "uv pip install " or venv_path .. "/bin/python -m pip install ") .. name
        vim.uv.spawn("/bin/sh", {
            args = { "-c", install_command },
        }, function(code, signal)
            if code ~= 0 then
                handle.message = "Failed!"
                handle:cancel()
                return vim.notify("Failed to install '" .. name .. "' into the virtual environment '" .. venv_path .. "'.", vim.log.levels.ERROR, { title = "Python Support" })
            end

            handle.message = "Installed!"
            handle:finish()

            if on_success then
                on_success()
            end
        end)
    end

    -- Check if package is already installed, then try installing it
    check_if_installed(function(code)
        if code == 0 then
            handle.message = "Present"
            handle:cancel()
        else
            install_package()
        end
    end)
end

M.install_dependencies = function()
    M.install_package_in_venv("debugpy")
    M.install_package_in_venv("black")
    M.install_package_in_venv("isort")
    M.install_package_in_venv("pynvim", function()
        vim.schedule(function()
            vim.cmd("UpdateRemotePlugins")
        end)
    end)
end

M.activate_venv = function(venv_path, source, type)
    local python_path = venv_path .. "/bin/python"
    if vim.fn.filereadable(python_path) == 0 then
        vim.notify("Virtual Environment '" .. python_path .. "' no longer exists.", vim.log.levels.ERROR, { title = "Python Support" })
        return
    end

    -- Activate the virtual environment
    require("_config.archive.venv-selector").activate_from_path(python_path)
    -- Restart the LSP
    vim.cmd([[LspRestart]])
    -- Notify the user
    vim.notify("Virtual environment activated.\n" .. require("_config.archive.venv-selector").venv(), vim.log.levels.INFO, { title = "Python Support" })
    -- Install dependencies into the virtual environment
    M.install_dependencies()
end

M.create_venv_in_cwd = function()
    if vim.fn.isdirectory(".venv") == 1 then
        vim.notify("Virtual environment already exists.", vim.log.levels.INFO, { title = "Python Support" })
        return
    end

    local handle = require("fidget.progress").handle.create({
        title = "Virtual Env",
        message = "Creating...",
        lsp_client = { name = "python-support" },
    })

    vim.uv.spawn("python", { args = { "-m", "venv", ".venv" } }, function(code, signal)
        if code ~= 0 then
            handle.message = "Failed!"
            handle:cancel()
            return
        end

        handle.message = "Created!"
        handle:finish()

        -- Activate the virtual environment
        vim.schedule(function()
            local path = vim.fn.getcwd() .. "/.venv"
            M.activate_venv(path, "venv", "workspace")
        end)
    end)
end

M.deactivate = function()
    require("_config.archive.venv-selector").deactivate()
    require("venv-selector.path").current_python_path = nil
    require("venv-selector.path").current_venv_path = nil
end

return M
