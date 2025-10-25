-- +---------------------------------------------------------+
-- | MagicDuck/grug-far.nvim                                 |
-- +---------------------------------------------------------+

local grug_far = require("grug-far")

-- Function to save modified buffers before grug-far operations
local function save_modified_buffers()
    local saved_buffers = {}
    local buffers = vim.api.nvim_list_bufs()

    for _, buf in ipairs(buffers) do
        -- Check if buffer is loaded, valid, and modified
        if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_get_option_value("modified", { buf = buf }) then
            local buf_name = vim.api.nvim_buf_get_name(buf)
            if buf_name and buf_name ~= "" then
                -- Save the buffer
                vim.api.nvim_buf_call(buf, function()
                    vim.cmd("silent! write")
                end)
                table.insert(saved_buffers, buf_name)
            end
        end
    end

    -- Notify user if buffers were saved
    if #saved_buffers > 0 then
        local message = string.format("grug-far: Saved %d modified buffer%s before sync", #saved_buffers, #saved_buffers > 1 and "s" or "")
        vim.notify(message, vim.log.levels.INFO)

        -- Show which buffers were saved in verbose mode
        if vim.o.verbose > 0 then
            for _, buf_name in ipairs(saved_buffers) do
                vim.notify("  • " .. vim.fn.fnamemodify(buf_name, ":~:."), vim.log.levels.INFO)
            end
        end
    end

    return #saved_buffers
end

-- Wrapper functions that save modified buffers before grug-far operations
local function wrap_instance_method(original_method)
    return function(self, ...)
        save_modified_buffers()
        return original_method(self, ...)
    end
end

-- Hook into grug-far instance creation to wrap the sync methods
local original_open = grug_far.open
local original_with_visual_selection = grug_far.with_visual_selection

local function wrap_instance(instance)
    if instance and instance.replace then
        -- Wrap the instance methods that modify files
        instance.replace = wrap_instance_method(instance.replace)
        instance.sync_all = wrap_instance_method(instance.sync_all)
        instance.sync_line = wrap_instance_method(instance.sync_line)
        instance.sync_file = wrap_instance_method(instance.sync_file)
    end
    return instance
end

-- Override the open functions to wrap returned instances
function grug_far.open(options)
    local instance = original_open(options)
    return wrap_instance(instance)
end

function grug_far.with_visual_selection(options)
    local instance = original_with_visual_selection(options)
    return wrap_instance(instance)
end

-- Also wrap existing instances when they are retrieved
local original_get_instance = grug_far.get_instance
function grug_far.get_instance(...)
    local instance = original_get_instance(...)
    return wrap_instance(instance)
end

grug_far.setup({})

-- stylua: ignore start
vim.keymap.set("n", "<C-f>", function() grug_far.open() end, { desc = "Find & Replace (all files)" })
vim.keymap.set("n", "<C-F>", function() grug_far.open({ prefills = { paths = vim.fn.expand("%") } }) end, { desc = "Find & Replace (current file)" })
vim.keymap.set("v", "<C-f>", function() grug_far.with_visual_selection({ prefills = { paths = vim.fn.expand('%') } }) end, { desc = "Find & Replace (current file)" })
vim.keymap.set("v", "<C-F>", function() grug_far.with_visual_selection() end, { desc = "Find & Replace (all files)" })
-- stylua: ignore end
