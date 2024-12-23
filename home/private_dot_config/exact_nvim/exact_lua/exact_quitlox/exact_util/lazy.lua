local M = {}

M.keymap_stub = function(mode, lhs, callback, opts)
    vim.keymap.set(mode, lhs, function()
        vim.keymap.del(mode, lhs)
        callback()
        vim.api.nvim_input(lhs) -- replay keybind
    end, opts)
end

M.command_stub = function(c, callback)
    vim.api.nvim_create_user_command(c, function()
        vim.api.nvim_del_user_command(c) -- remove stub command
        callback()
        vim.cmd(c)
    end, {})
end

-- From lz.n
-- https://github.com/nvim-neorocks/lz.n/blob/3d36b6848fc67f6a13d2a52cf4f96fd3403c0c43/lua/lz/n/handler/cmd.lua
M.command_stub_args = function(cmd, load)
    vim.api.nvim_create_user_command(cmd, function(event)
        ---@cast event vim.api.keyset.user_command
        local command = {
            cmd = cmd,
            bang = event.bang or nil,
            ---@diagnostic disable-next-line: undefined-field
            mods = event.smods,
            ---@diagnostic disable-next-line: undefined-field
            args = event.fargs,
            count = event.count >= 0 and event.range == 0 and event.count or nil,
        }

        if event.range == 1 then
            ---@diagnostic disable-next-line: undefined-field
            command.range = { event.line1 }
        elseif event.range == 2 then
            ---@diagnostic disable-next-line: undefined-field
            command.range = { event.line1, event.line2 }
        end

        vim.api.nvim_del_user_command(cmd)
        load()

        local info = vim.api.nvim_get_commands({})[cmd] or vim.api.nvim_buf_get_commands(0, {})[cmd]
        if not info then
            vim.schedule(function()
                ---@type string
                local plugins = "`" .. table.concat(vim.tbl_values(M.pending[cmd]), ", ") .. "`"
                vim.notify("Command `" .. cmd .. "` not found after loading " .. plugins, vim.log.levels.ERROR)
            end)
            return
        end

        command.nargs = info.nargs
        ---@diagnostic disable-next-line: undefined-field
        if event.args and event.args ~= "" and info.nargs and info.nargs:find("[1?]") then
            ---@diagnostic disable-next-line: undefined-field
            command.args = { event.args }
        end
        vim.cmd(command)
    end, {
        bang = true,
        range = true,
        nargs = "*",
        complete = function(_, line)
            vim.api.nvim_del_user_command(cmd)
            load()
            return vim.fn.getcompletion(line, "cmdline")
        end,
    })
end

M.require_stub = function(mod, callback)
    package.preload[mod] = function()
        return callback()
    end
end

--- From Snacks.util
--- https://github.com/folke/snacks.nvim/blob/98df370703b3c47a297988f3e55ce99628639590/lua/snacks/util.lua#L162

local uv = vim.uv or vim.loop
local mod_timer = assert(uv.new_timer())
local mod_cb = {} ---@type table<string, fun(modname:string)[]>

---@return boolean waiting
M.mod_check = function()
    for modname, cbs in pairs(mod_cb) do
        if package.loaded[modname] then
            mod_cb[modname] = nil
            for _, cb in ipairs(cbs) do
                cb(modname)
            end
        end
    end
    return next(mod_cb) ~= nil
end

--- Call a function when a module is loaded.
--- The callback is called immediately if the module is already loaded.
--- Otherwise, it is called when the module is loaded.
---@param modname string
---@param cb fun(modname:string)
function M.on_module(modname, cb)
    mod_cb[modname] = mod_cb[modname] or {}
    table.insert(mod_cb[modname], cb)
    if M.mod_check() then
        mod_timer:start(
            100,
            100,
            vim.schedule_wrap(function()
                return not M.mod_check() and mod_timer:stop()
            end)
        )
    end
end

return M
