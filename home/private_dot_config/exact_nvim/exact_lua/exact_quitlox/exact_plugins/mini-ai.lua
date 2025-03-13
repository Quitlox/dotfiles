-- +---------------------------------------------------------+
-- | mini.align: Enhance the `a` and `i` operators           |
-- +---------------------------------------------------------+
-- Implement the `a` and `i` operators. The mini.ai plugin provides the
-- functionality of `targets.vim` (a simpler algorithm based plugin for
-- brackets, separators and arguments) and nvim-treesitter-textobjects, which
-- provides queries for integration with textobjects.
--
-- The `mini.ai` plugin uses the queries provided by
-- nvim-treesitter-textobjects, so that plugin is a dependency.
--
-- Note that this plugin should note be combined with any other similar plugins
-- (`targets.nvim`, `nvim-various-textobjs`, etc.), as the mappings will
-- overlap and inconsistencies.

-- Notes --------------------------------------------------+
-- NOTE: Possible objects to implement:
-- - subword
-- - mdlink
-- - pytriplequotes

-- NOTE: Filetype specific textobjects currently configured in:
-- - ftplugin/python.lua

-- Setup --------------------------------------------------+
local gen_spec = require("mini.ai").gen_spec
local mini_ai_opts = {
    -- search_method = "cover_or_nearest",
    custom_textobjects = {
        f = gen_spec.treesitter({
            a = "@function.outer",
            i = "@function.inner",
        }),
        c = gen_spec.treesitter({
            a = "@class.outer",
            i = "@class.inner",
        }),
        d = gen_spec.treesitter({
            a = "@statement.outer",
            i = "@statement.inner",
        }),
        o = gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }),
        i = require("mini.extra").gen_ai_spec.indent(),

        -- a = spec_treesitter({
        --     a = { "@attribute.outer", "@parameter.outer" },
        --     i = { "@attribute.inner", "@parameter.inner" },
        -- }),

        -- From LazyVim
        t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        u = gen_spec.function_call(), -- u for "Usage"
        U = gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
    },
}
require("mini.ai").setup(mini_ai_opts)

-- Integration: Which-Key ---------------------------------+
-- Note that due to the inherent design of `mini.ai`, the which-key popup won't
-- show if entering operator-pending mode without waiting for the which-key
-- popup timeout. This is because mini.ai takes control over the input.

--- Register all text objects from mini.ai with which-key for the `a` and `i` operators.
--- Taken from LazyVim (https://github.com/LazyVim/LazyVim/blob/d0c366e4d861b848bdc710696d5311dca2c6d540/lua/lazyvim/util/mini.lua#L23)
---@param opts table
local function ai_whichkey(opts)
    local objects = {
        { " ", desc = "whitespace" },
        { '"', desc = '" string' },
        { "'", desc = "' string" },
        { "(", desc = "() block" },
        { ")", desc = "() block with ws" },
        { "<", desc = "<> block" },
        { ">", desc = "<> block with ws" },
        { "?", desc = "user prompt" },
        { "U", desc = "use/call without dot" },
        { "[", desc = "[] block" },
        { "]", desc = "[] block with ws" },
        { "_", desc = "underscore" },
        { "`", desc = "` string" },
        { "a", desc = "argument" },
        { "b", desc = ")]} block" },
        { "c", desc = "class" },
        { "d", desc = "digit(s)" },
        { "e", desc = "CamelCase / snake_case" },
        { "f", desc = "function" },
        { "g", desc = "entire file" },
        { "i", desc = "indent" },
        { "o", desc = "block, conditional, loop" },
        { "q", desc = "quote `\"'" },
        { "t", desc = "tag" },
        { "u", desc = "use/call" },
        { "{", desc = "{} block" },
        { "}", desc = "{} with ws" },
    }

    ---@type wk.Spec[]
    local ret = { mode = { "o", "x" } }
    ---@type table<string, string>
    local mappings = vim.tbl_extend("force", {}, {
        around = "a",
        inside = "i",
        around_next = "an",
        inside_next = "in",
        around_last = "al",
        inside_last = "il",
    }, opts.mappings or {})
    mappings.goto_left = nil
    mappings.goto_right = nil

    for name, prefix in pairs(mappings) do
        name = name:gsub("^around_", ""):gsub("^inside_", "")
        ret[#ret + 1] = { prefix, group = name }
        for _, obj in ipairs(objects) do
            local desc = obj.desc
            if prefix:sub(1, 1) == "i" then
                desc = desc:gsub(" with ws", "")
            end
            ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
        end
    end
    require("which-key").add(ret, { notify = false })
end

-- Execute the which-key integration if the plugin is installed.
local ok, _ = pcall(require, "which-key")
if ok then
    ai_whichkey(mini_ai_opts)
end
