---@module my_loc_counter
---Counts total lines of code in the current git repository.
---Only works in git repositories and respects .gitignore.

local M = require("lualine.component"):extend()

-- Cache to avoid running the command on every statusline refresh
local cache = {
    cwd = nil,
    count = nil,
    last_update = 0,
}

-- Update interval in milliseconds (default: 30 seconds)
local UPDATE_INTERVAL = 30000

---Check if current directory is inside a git repository
---@return boolean
local function is_git_repo()
    local handle = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
    if not handle then
        return false
    end
    local result = handle:read("*a")
    handle:close()
    return result:match("true") ~= nil
end

---Count lines of code using git ls-files and wc
---@return number|nil
local function count_loc()
    -- Use git ls-files to get tracked files (respects .gitignore)
    -- Then use xargs with wc -l to count lines
    local handle = io.popen("git ls-files 2>/dev/null | xargs wc -l 2>/dev/null | tail -1")
    if not handle then
        return nil
    end
    local result = handle:read("*a")
    handle:close()

    -- Parse the total from wc output (format: "  12345 total" or just "  12345")
    local count = result:match("^%s*(%d+)")
    return count and tonumber(count) or nil
end

---Format number with thousand separators
---@param num number
---@return string
local function format_number(num)
    local formatted = tostring(num)
    local k
    while true do
        formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        if k == 0 then
            break
        end
    end
    return formatted
end

function M:init(options)
    options.icon = options.icon or "󰈙"
    M.super.init(self, options)
end

function M:update_status()
    local cwd = vim.fn.getcwd()
    local now = vim.loop.now()

    -- Check if cache is still valid
    if cache.cwd == cwd and cache.count and (now - cache.last_update) < UPDATE_INTERVAL then
        return format_number(cache.count)
    end

    -- Check if we're in a git repo
    if not is_git_repo() then
        cache.cwd = cwd
        cache.count = nil
        cache.last_update = now
        return ""
    end

    -- Update cache asynchronously to avoid blocking
    -- For the first call or cache miss, we do a synchronous call
    local count = count_loc()
    if count then
        cache.cwd = cwd
        cache.count = count
        cache.last_update = now
        return format_number(count)
    end

    return ""
end

-- Condition: only show in git repositories
function M:cond()
    return is_git_repo()
end

return M
