-- Mostly borrowed from LazyVim
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/init.lua

local M = {}

function M.whichkey(opts)
    return {
        "folke/which-key.nvim",
        optional = true,
        opts = {
            defaults = opts,
        },
    }
end

function M.legendary(commands)
    local function insert_commands(_, opts)
        opts.commands = opts.commands or {}
        for _, command in ipairs(commands) do
            table.insert(opts.commands, { command[1], description = command[2] })
        end
    end

    return {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = insert_commands,
    }
end

function M.legendary_full(commands)
    local function insert_commands(_, opts)
        opts.commands = opts.commands or {}
        for _, command in ipairs(commands) do
            table.insert(opts.commands, command)
        end
    end

    return {
        "mrjones2014/legendary.nvim",
        optional = true,
        opts = insert_commands,
    }
end

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buffer)
        end,
    })
end

---@param plugin string
function M.has(plugin) return require("lazy.core.config").plugins[plugin] ~= nil end

-- this will return a function that calls telescope.
-- cwd will default to lazyvim.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.telescope(builtin, opts)
    local params = { builtin = builtin, opts = opts }
    return function()
        builtin = params.builtin
        opts = params.opts
        opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
        if builtin == "files" then
            if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
                opts.show_untracked = true
                builtin = "git_files"
            else
                builtin = "find_files"
            end
        end
        if opts.cwd and opts.cwd ~= vim.loop.cwd() then
            opts.attach_mappings = function(_, map)
                map("i", "<a-c>", function()
                    local action_state = require("telescope.actions.state")
                    local line = action_state.get_current_line()
                    M.telescope(params.builtin, vim.tbl_deep_extend("force", {}, params.opts or {}, { cwd = false, default_text = line }))()
                end)
                return true
            end
        end

        require("telescope.builtin")[builtin](opts)
    end
end

function M.make_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    return capabilities
end

return M
