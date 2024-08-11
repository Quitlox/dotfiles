local M = {}

M.install_package_in_venv = function(name, on_success)
    local venv_path = vim.fn.getenv("VIRTUAL_ENV")

    -- Check if running in a virtual environment
    if venv_path == vim.v.null or venv_path == "" then return end

    local handle = require("fidget.progress").handle.create({
        title = name,
        message = "Installing...",
        lsp_client = { name = "python-support" },
    })

    -- Check if package is already installed
    vim.uv.spawn(venv_path .. "/bin/pip", { args = { "show", name } }, function(code, signal)
        if code == 0 then
            handle.message = "Present"
            handle:cancel()
            return
        end

        -- Attempt to install package using pip
        vim.uv.spawn(venv_path .. "/bin/pip", { args = { "install", name } }, function(code, signal)
            if code ~= 0 then
                handle.message = "Failed!"
                handle:cancel()
                return vim.notify("Failed to install '" .. name .. "' into the virtual environment '" .. venv_path .. "'.", vim.log.levels.ERROR, { title = "Python Support" })
            end

            handle.message = "Installed!"
            handle:finish()

            if on_success then on_success() end
        end)
    end)
end

M.install_dependencies = function()
    -- Install debugpy
    M.install_package_in_venv("debugpy")
    -- Install black
    M.install_package_in_venv("black")
    -- Install isort
    M.install_package_in_venv("isort")
    -- Install pynvim
    M.install_package_in_venv("pynvim", function()
        vim.schedule(function() vim.cmd("UpdateRemotePlugins") end)
    end)
end

-- After PR
M.activate_venv = function(venv_path, source, type)
    local python_path = venv_path .. "/bin/python"
    if vim.fn.filereadable(python_path) == 0 then
        vim.notify("Virtual Environment '" .. python_path .. "' no longer exists.", vim.log.levels.ERROR, { title = "Python Support" })
        return
    end

    require("venv-selector").activate(python_path, type)
    vim.notify("Virtual environment activated.\n" .. require("venv-selector").venv(), vim.log.levels.INFO, { title = "Python Support" })

    M.install_dependencies()
end

-- -- Before PR
-- --- Activate the given Virtual Environment using venv-selector.nvim
-- --- Copied from 'venv-selector.gui'
-- ---@param venv_path The path to the virtual environment (base path)
-- ---@param source The source with which the venv was found (cwd, workspace, etc..)
-- ---@param type The type of the virtual environment (venv, anaconda, etc..)
-- M.activate_venv = function(venv_path, source, type)
--     -- Copied from venv-selector.gui
--     local hooks = require("venv-selector.config").user_settings.hooks
--     local venv = require("venv-selector.venv")
--     local path = require("venv-selector.path")
--
--     venv_path = venv_path .. "/bin/python"
--     local activated = require("venv-selector.venv").activate(hooks, {
--         path = venv_path,
--         type = type,
--         source = source,
--     })
--
--     if activated == true then
--         path.add(path.get_base(venv_path))
--         path.update_python_dap(venv_path)
--         path.save_selected_python(venv_path)
--
--         if type == "anaconda" then
--             venv.unset_env("VIRTUAL_ENV")
--             venv.set_env(venv_path, "CONDA_PREFIX")
--         else
--             venv.unset_env("CONDA_PREFIX")
--             venv.set_env(venv_path, "VIRTUAL_ENV")
--         end
--     end
--
--     vim.notify("Virtual environment activated.\n" .. require("venv-selector").venv(), vim.log.levels.INFO, { title = "Python Support" })
--     M.install_dependencies()
-- end

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
    require("venv-selector").deactivate()
    require("venv-selector.path").current_python_path = nil
    require("venv-selector.path").current_venv_path = nil
end

return M
