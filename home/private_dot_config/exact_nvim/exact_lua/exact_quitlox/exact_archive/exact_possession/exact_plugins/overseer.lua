-- NOTE: Possession doesn't actually support custom plugins yet, so this is loaded manually in my config.

local M = {}

function M.before_save(opts, name)
    if name == nil then
        return true
    end

    require("overseer").save_task_bundle(name, nil, { on_conflict = "overwrite" })
    require("overseer").close()
end

function M.before_load(opts, name)
    -- Optionally get rid of all previous tasks when restoring a session
    for _, task in ipairs(require("overseer").list_tasks({})) do
        task:dispose(true)
    end
end

function M.after_load(opts, name, plugin_data)
    if name == nil then
        return true
    end

    -- Load the task bundle for the current directory
    require("overseer").load_task_bundle(name, { ignore_missing = true })
end

return M
