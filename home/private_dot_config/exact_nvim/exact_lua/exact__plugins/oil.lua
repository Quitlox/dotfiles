-- +---------------------------------------------------------+
-- | stevearc/oil.nvim                                       |
-- +---------------------------------------------------------+

--+- Setup: Close Buffers on File Delete --------------------+
--- Should be called after saving an oil buffer.
---
--- This function will check if all open buffers still match a file on disk.
--- If the file on disk has been deleted, and the buffer is unmodified, delete the buffer.
local function on_save_callback()
    -- Use a small delay to ensure file operations are complete
    vim.defer_fn(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local path = vim.api.nvim_buf_get_name(buf)
            if not path or path == "" then
                goto continue
            end
            if vim.startswith(path, "oil://") then
                goto continue
            end
            if vim.startswith(path, "neo-tree") then
                goto continue
            end

            -- Normalize path for more reliable checking
            local normalized_path = vim.fn.fnamemodify(path, ":p")
            if not vim.loop.fs_stat(normalized_path) then
                vim.schedule(function()
                    -- Try to directly delete the buffer using vim.api
                    local success, res = pcall(function()
                        -- Check if buffer is loaded and exists
                        if vim.api.nvim_buf_is_valid(buf) then
                            -- Handle unmodified buffers (force delete)
                            vim.api.nvim_buf_delete(buf, { force = true })
                            return true
                        end
                        return false
                    end)

                    if not success then
                        vim.notify("Failed to delete buffer: " .. vim.inspect(res), vim.log.levels.ERROR, { title = "Oil Support" })
                    end
                end)
            end

            ::continue::
        end
    end, 100) -- 100ms delay to give the filesystem time to update
end

--+- Setup: Hidden Files ------------------------------------+
-- helper function to parse output
local function parse_output(proc)
    local result = proc:wait()
    local ret = {}
    if result.code == 0 then
        for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
            -- Remove trailing slash
            line = line:gsub("/$", "")
            ret[line] = true
        end
    end

    return ret
end

-- build git status cache
local function new_git_status()
    return setmetatable({}, {
        __index = function(self, key)
            local ignore_proc = vim.system({ "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" }, {
                cwd = key,
                text = true,
            })
            local tracked_proc = vim.system({ "git", "ls-tree", "HEAD", "--name-only" }, {

                cwd = key,
                text = true,
            })
            local ret = {

                ignored = parse_output(ignore_proc),
                tracked = parse_output(tracked_proc),
            }

            rawset(self, key, ret)
            return ret
        end,
    })
end

local git_status = new_git_status()

-- Clear git status cache on refresh
local refresh = require("oil.actions").refresh
local orig_refresh = refresh.callback
refresh.callback = function(...)
    git_status = new_git_status()
    orig_refresh(...)
end

local is_hidden_file = function(name, bufnr)
    local dir = require("oil").get_current_dir(bufnr)
    local is_dotfile = vim.startswith(name, ".") and name ~= ".."
    -- if no local directory (e.g. for ssh connections), just hide dotfiles
    if not dir then
        return is_dotfile
    end
    -- dotfiles are considered hidden unless tracked

    if is_dotfile then
        return not git_status[dir].tracked[name]
    else
        -- Check if file is gitignored
        return git_status[dir].ignored[name]
    end
end

--+- Setup --------------------------------------------------+
require("oil").setup({
    default_file_explorer = true,
    skip_confirm_for_simple_edits = true,
    watch_for_changes = true,
    keymaps = {
        ["q"] = "actions.close",
        ["<esc>"] = "actions.close",
        ["<C-s>"] = { callback = require("oil").save, desc = "Commit the changes", mode = "n" },
        ["<C-b>"] = "actions.select_vsplit",
        ["<C-v>"] = "actions.select_split",
        ["<C-h>"] = false,
    },
    view_options = {
        is_hidden_file = is_hidden_file,
    },
})

-- Run on_save_callback when saving an oil buffer through :w
vim.api.nvim_create_autocmd("BufLeave", {
    group = vim.api.nvim_create_augroup("OilOnSave", { clear = true }),
    desc = "Clean up buffers for deleted files after saving oil buffer",
    callback = function(event)
        local filetype = vim.api.nvim_get_option_value("filetype", { buf = event.buf })
        if filetype == "oil_preview" then
            vim.notify("Cleaned up buffers for deleted files.", "info", { title = "Oil Support" })
            on_save_callback()
        end
    end,
})

--+- Keymaps ------------------------------------------------+
-- stylua: ignore start
vim.keymap.set("n", "-", function() require("oil").open_float() end, { noremap = true, silent = true, desc = "oil: Open" })
vim.keymap.set("n", "_", function() require("oil").open() end, { noremap = true, silent = true, desc = "oil: Open (as Buffer)" })

--+- Commands -----------------------------------------------+
vim.api.nvim_create_user_command("Oil", function() require("oil").open_float() end, { desc = "oil: Open" })
vim.api.nvim_create_user_command("OilBuf", function() require("oil").open() end, { desc = "oil: Open (as Buffer)" })
vim.api.nvim_create_user_command("OilRoot", function() require("oil").open_float(vim.fn.getcwd()) end, { desc = "oil: Open in project root" })
vim.api.nvim_create_user_command("OilDiscard", function() require("oil").discard_all_changes() end, { desc = "oil: Discard changes" })
-- stylua: ignore end
