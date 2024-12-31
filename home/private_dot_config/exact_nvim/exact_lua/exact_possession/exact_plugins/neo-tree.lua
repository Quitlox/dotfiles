-- NOTE: Possession doesn't actually support custom plugins yet, so this is loaded manually in my config.

-- Hacking neo-tree to restore expanded dirs after session load

local M = {}

-- +- State --------------------------------------------------+
M.dirs_to_restore = nil

-- +- Helper Functions ---------------------------------------+
local resolve = function(filename)
    -- Replace symlink with real path
    filename = vim.fn.expand(filename)
    return vim.fn.resolve(filename)
end

local short_path = function(path)
    -- Reduce file name to be relative to the home directory, if possible.
    path = resolve(path)
    return vim.fn.fnamemodify(path, ":~")
end

local function filesystem_state()
    -- Returns a table with filesystem source state of neo-tree
    local installed, sm = pcall(require, "neo-tree.sources.manager")
    if not installed or sm == nil then
        return nil
    end
    local ok, state = pcall(sm.get_state, "filesystem")
    if ok then
        return state
    else
        return nil
    end
end

-- +- Main Functions -----------------------------------------+

--- Restore the state of the neotree.
---
--- Call this function after a session is loaded, and M.dirs_to_restore is set
--- with the directories to restore. The neo-tree must be opened for this to
--- work.
---
--- Each time this function is called, it will pop one directory off
--- M.dirs_to_restore and expand it. After expanding, the state is refreshed,
--- triggering a rerender and thus a new call to this method to expand the next
--- directory.
local function restore_neotree()
    if M.dirs_to_restore ~= nil and #M.dirs_to_restore > 0 then
        local state = filesystem_state()
        if state == nil then
            return
        end
        if state.tree == nil then
            return
        end -- filesystem not ready
        if state.explicitly_opened_directories == nil then
            state.explicitly_opened_directories = {}
        end

        -- Pop the first directory from the list and expand it
        local dir = table.remove(M.dirs_to_restore, 1)
        state.explicitly_opened_directories[dir] = true
        local node = state.tree:get_node(dir)
        if node ~= nil then
            node:expand()
        end

        -- Refresh tree to load children
        state.commands["refresh"](state)
    end
end

--- Get the state of Neo-tree, determining which directories are explicitly
--- opened and need to be restored.
---@return table|nil A list of directories to restore, or nil if none.
local get_neotree_state = function()
    local state = filesystem_state()
    local restore = {}

    -- Gather directories to restore from M.dirs_to_restore
    -- M.dirs_to_restore may not be empty if no neo-tree was opened yet
    -- (i.e. we didn't yet get to restore since loading the session)
    if M.dirs_to_restore then
        for _, path in ipairs(M.dirs_to_restore) do
            restore[path] = true
        end
    end

    -- Include explicitly opened directories from the current state
    if state and state.explicitly_opened_directories then
        for path, opened in pairs(state.explicitly_opened_directories) do
            if opened then
                restore[path] = true
            end
        end
    end

    -- Filter directories that are subdirectories of the current working directory and exist
    local data = {}
    local cwd = vim.loop.cwd()
    for dir in pairs(restore) do
        if vim.startswith(dir, cwd) and vim.fn.isdirectory(vim.fn.expand(short_path(dir))) == 1 then
            table.insert(data, short_path(dir))
        end
    end

    -- Filter out hidden directories (those that are in closed nodes)
    local filtered_data = {}
    cwd = short_path(cwd)
    for _, path in ipairs(data) do
        local parent = short_path(vim.fn.fnamemodify(vim.fn.expand(path), ":h"))
        local has_parent = parent == cwd

        if not has_parent then
            for _, p in ipairs(data) do
                if p == parent then
                    has_parent = true
                    break
                end
            end
        end

        if has_parent then
            table.insert(filtered_data, path)
        end
    end

    return next(filtered_data) == nil and nil or filtered_data
end

--- Set the state of the neotree given the data from the session.
---
--- This function is called after a session is loaded. It sets the state
--- M.dirs_to_restore to the directories that were opened in the neo-tree in
--- the previous session.
---
--- The directories are given as relative paths, and are converted to absolute
--- paths.
---@param dirs_relative table The directories that were opened in the neo-tree in the previous session (produced by get_neotree_state)
local set_state_from_session = function(dirs_relative)
    -- Call this function after session load
    if dirs_relative == nil or #dirs_relative == 0 then
        return
    end
    local dirs_absolute = {}
    for _, path in ipairs(dirs_relative) do
        path = vim.fn.expand(path)
        table.insert(dirs_absolute, path)
    end

    -- sort dirs by depths before expanding
    -- nodes with bigger depths are not in the tree until parent is expanded
    table.sort(dirs_absolute, function(a, b)
        local _, depth_a = string.gsub(a, "/", "")
        local _, depth_b = string.gsub(b, "/", "")
        return depth_a < depth_b
    end)

    -- Impossible to restore state until user opens neo-tree because tree is not built yet
    M.dirs_to_restore = dirs_absolute -- save dirs to restore later in autocmd
end

-- +- Possession Hooks ---------------------------------------+
function M.before_save(opts, name)
    -- Save state of neo-tree
    return {
        opened_directories = get_neotree_state(),
    }
end

function M.after_load(opts, name, plugin_data)
    if plugin_data == nil then
        return
    end
    -- Set the state of neo-tree
    set_state_from_session(plugin_data.opened_directories)
end

-- +- Autocommand to restore neo-tree ------------------------+
function M.setup_events_for_neotree()
    local installed, events = pcall(require, "neo-tree.events")
    if not installed then
        vim.notify("Neovim-project: neo-tree.events is not found", vim.log.levels.WARN, { title = "Possession: Neo-Tree Plugin" })
        return
    end
    events.subscribe({
        event = events.AFTER_RENDER,
        handler = restore_neotree,
    })
end

return M
