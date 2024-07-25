local function keymap_stub(mode, lhs, callback, opts)
    vim.keymap.set(mode, lhs, function()
        vim.keymap.del(mode, lhs)
        callback()
        vim.api.nvim_input(lhs) -- replay keybind
    end, opts)
end

local function command_stub(c, callback)
    vim.api.nvim_create_user_command(c, function()
        vim.api.nvim_del_user_command(c) -- remove stub command
        callback()
        vim.cmd(c)
    end, {})
end

local function require_stub(mod, callback)
    package.preload[mod] = function()
        package.loaded[mod] = nil
        package.preload[mod] = nil
        return callback()
    end
end

return {
    keymap_stub = keymap_stub,
    command_stub = command_stub,
    require_stub = require_stub,
}
