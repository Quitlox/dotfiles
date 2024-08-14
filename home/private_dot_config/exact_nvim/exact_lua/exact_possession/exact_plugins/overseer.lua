-- NOTE: Possession doesn't actually support custom plugins yet, so this is loaded manually in my config.

local M = {}

-- Convert the cwd to a simple file name
local function get_cwd_as_name()
    local dir = vim.fn.getcwd(0)
    return dir:gsub("[^A-Za-z0-9]", "_")
end

function M.before_save(opts, name)
    -- Save the task bundle for the current directory
    require("overseer").save_task_bundle(
        get_cwd_as_name(),
        -- Passing nil will use config.opts.save_task_opts. You can call list_tasks() explicitly and
        -- pass in the results if you want to save specific tasks.
        nil,
        { on_conflict = "overwrite" } -- Overwrite existing bundle, if any
    )
end

function M.before_load(opts, name)
    -- Optionally get rid of all previous tasks when restoring a session
    for _, task in ipairs(require("overseer").list_tasks({})) do
        task:dispose(true)
    end
end

function M.after_load(opts, name, plugin_data)
    -- Load the task bundle for the current directory
    require("overseer").load_task_bundle(get_cwd_as_name(), { ignore_missing = true })
end

return M
