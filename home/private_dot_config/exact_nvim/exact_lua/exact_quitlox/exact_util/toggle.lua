-- Credits LazyVim
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/toggle.lua

---@class quitlox.util.toggle
local M = {}

---@class quitlox.util.Toggle
---@field name string
---@field get fun():boolean
---@field set fun(state:boolean)

---@class quitlox.Toggle.wrap: quitlox.util.Toggle
---@operator call:boolean

-- +---------------------------------------------------------+
-- | Helper Functions for Defining Toggles                   |
-- +---------------------------------------------------------+

---@param toggle quitlox.util.Toggle
---@param notify? boolean
function M.wrap(toggle, notify)
    return setmetatable(toggle, {
        __call = function()
            toggle.set(not toggle.get())
            local state = toggle.get()

            if notify == nil then notify = true end
            if state then
                if notify then vim.notify("Enabled " .. toggle.name, vim.log.levels.INFO, { title = toggle.name }) end
            else
                if notify then vim.notify("Disabled " .. toggle.name, vim.log.levels.WARN, { title = toggle.name }) end
            end
            return state
        end,
    })
end

---@param lhs string
---@param toggle quitlox.util.Toggle
---@param notify? boolean
function M.map(lhs, toggle, notify)
    local t = M.wrap(toggle, notify)
    vim.keymap.set("n", lhs, function() t() end, { desc = "Toggle " .. toggle.name })
    M.wk(lhs, toggle)
end

function M.wk(lhs, toggle)
    require("which-key").add({
        {
            lhs,
            icon = function() return toggle.get() and { icon = " ", color = "green" } or { icon = " ", color = "yellow" } end,
            desc = function() return (toggle.get() and "Disable " or "Enable ") .. toggle.name end,
        },
    })
end

-- +---------------------------------------------------------+
-- | Predefine Toggles                                       |
-- +---------------------------------------------------------+

M.treesitter = M.wrap({
    name = "Treesitter Highlight",
    get = function() return vim.b.ts_highlight end,
    set = function(state)
        if state then
            vim.treesitter.start()
        else
            vim.treesitter.stop()
        end
    end,
})

---@param buf? boolean
function M.format(buf)
    local format = require("quitlox.util.format")
    return M.wrap({
        name = "Auto Format (" .. (buf and "Buffer" or "Global") .. ")",
        get = function()
            if not buf then return vim.g.autoformat == nil or vim.g.autoformat end
            return format.enabled()
        end,
        set = function(state) format.enable(state, buf) end,
    })
end

---@param opts? {values?: {[1]:any, [2]:any}, name?: string}
function M.option(option, opts)
    opts = opts or {}
    local name = opts.name or option
    local on = opts.values and opts.values[2] or true
    local off = opts.values and opts.values[1] or false
    return M.wrap({
        name = name,
        get = function() return vim.opt_local[option]:get() == on end,
        set = function(state) vim.opt_local[option] = state and on or off end,
    })
end

local nu = { number = true, relativenumber = true }
M.number = M.wrap({
    name = "Line Numbers",
    get = function() return vim.opt_local.number:get() or vim.opt_local.relativenumber:get() end,
    set = function(state)
        if state then
            vim.opt_local.number = nu.number
            vim.opt_local.relativenumber = nu.relativenumber
        else
            nu = { number = vim.opt_local.number:get(), relativenumber = vim.opt_local.relativenumber:get() }
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
        end
    end,
})

M.diagnostics = M.wrap({
    name = "Diagnostics",
    get = function() return vim.diagnostic.is_enabled and vim.diagnostic.is_enabled() end,
    set = vim.diagnostic.enable,
})

M.inlay_hints = M.wrap({
    name = "Inlay Hints",
    get = function() return vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }) end,
    set = function(state) vim.lsp.inlay_hint.enable(state, { bufnr = 0 }) end,
})

---@type {k:string, v:any}[]
M._maximized = nil
M.maximize = M.wrap({
    name = "Maximize",
    get = function() return M._maximized ~= nil end,
    set = function(state)
        if state then
            M._maximized = {}
            local function set(k, v)
                table.insert(M._maximized, 1, { k = k, v = vim.o[k] })
                vim.o[k] = v
            end
            set("winwidth", 999)
            set("winheight", 999)
            set("winminwidth", 10)
            set("winminheight", 4)
            vim.cmd("wincmd =")
            -- `QuitPre` seems to be executed even if we quit a normal window, so we don't want that
            -- `VimLeavePre` might be another consideration? Not sure about differences between the 2
            vim.api.nvim_create_autocmd("ExitPre", {
                once = true,
                group = vim.api.nvim_create_augroup("lazyvim_restore_max_exit_pre", { clear = true }),
                desc = "Restore width/height when close Neovim while maximized",
                callback = function() M.maximize.set(false) end,
            })
        else
            for _, opt in ipairs(M._maximized) do
                vim.o[opt.k] = opt.v
            end
            M._maximized = nil
            vim.cmd("wincmd =")
        end
    end,
})

-- +---------------------------------------------------------+
-- | Configure Toggles                                       |
-- +---------------------------------------------------------+

M.map("<leader>Tf", M.format(true))
M.map("<leader>TF", M.format())
M.map("<leader>Tt", M.treesitter)
M.map("<leader>Th", M.inlay_hints)
M.map("<leader>Td", M.diagnostics)

-- +---------------------------------------------------------+
-- | Export                                                  |
-- +---------------------------------------------------------+

setmetatable(M, {
    __call = function(m, ...) return m.option(...) end,
})

return M
