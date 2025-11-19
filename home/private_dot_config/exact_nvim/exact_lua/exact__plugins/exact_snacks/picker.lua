-- +---------------------------------------------------------+
-- | snacks.nvim: Picker                                     |
-- +---------------------------------------------------------+

-- Function to create projects picker configuration with different behaviors
---@param opts table Configuration options
---@param opts.should_reset boolean Whether to reset when loading sessions (default: true)
---@param opts.confirm_non_tab_sessions boolean Whether to confirm when loading non-tab sessions (default: false)
---@param opts.close_everything_when_no_session boolean Whether to close everything when no session found (default: same as should_reset)
local function create_projects_picker_config(opts)
    opts = opts or {}
    local should_reset = opts.should_reset ~= false -- default true
    local confirm_non_tab_sessions = opts.confirm_non_tab_sessions == true
    local close_everything_when_no_session = opts.close_everything_when_no_session
    if close_everything_when_no_session == nil then
        close_everything_when_no_session = should_reset
    end

    return {
        dev = { "~/Workspace/activism", "~/Workspace/contrib", "~/Workspace/hobby", "~/Workspace/neovim-plugins", "~/Workspace/tno/pet-lab/", "~/Workspace/tno/projects/" },
        projects = { "~/.config/nvim", "~/.config/hypr", "~/.config/ansible", "~/Obsidian/Knowledge" },
        matcher = {
            frecency = true,
        },
        win = {
            input = {
                keys = {
                    ["<c-t>"] = {
                        function(picker)
                            -- Close current picker
                            picker:close()
                            -- Open in new tab with the same configuration
                            vim.schedule(function()
                                vim.cmd("tabnew")
                                Snacks.picker.projects(create_projects_picker_config(opts))
                            end)
                        end,
                        desc = "Open in new tab",
                        mode = { "i", "n" },
                    },
                },
            },
        },
        confirm = function(picker, item)
            picker:close()
            if not item then
                return
            end

            local resession = require("resession")
            local resession_util = require("resession.util")
            local util = require("_config.util.session")

            -- Remove trailing slash from the selected path
            local path = item.file:gsub("/$", "")

            -- Save current session
            resession.save_tab(util.get_session_name(), { notify = false, attach = true })

            -- Stupid hack to wait for Neo-tree to close and open before/after saving
            vim.wait(100, function() end)

            -- Change to the selected directory (tab-scoped)
            vim.cmd("tcd " .. vim.fn.fnameescape(path))

            -- Load session for the new directory
            -- Expand the path to get the full absolute path
            local expanded_path = vim.fn.expand(path)
            local new_session_name = util.get_session_name(expanded_path)
            local session_file = resession_util.get_session_file(new_session_name)
            local session_basename = vim.fs.basename(session_file)
            local final_session_name = session_basename:gsub("%.json$", "")

            if vim.tbl_contains(resession.list(), final_session_name) then
                -- Check if we need to confirm for non-tab sessions
                local reset_to_use = should_reset
                local is_tab_session = false

                if confirm_non_tab_sessions and not should_reset then
                    -- Check if the session is tab-scoped by examining the session file
                    local files = require("resession.files")
                    local session_filename = resession_util.get_session_file(final_session_name)
                    local session_data = files.load_json_file(session_filename)
                    is_tab_session = session_data and session_data.tab_scoped or false

                    if not is_tab_session then
                        local choice = vim.fn.confirm(
                            "This session '" .. final_session_name .. "' appears to be a global session.\nLoading it will overwrite your entire editor state.\n\nDo you want to continue?",
                            "&Yes\n&No",
                            2
                        )
                        if choice ~= 1 then
                            return
                        end
                        reset_to_use = true
                    end
                end

                -- For tab-scoped sessions when we don't want to reset
                if is_tab_session and not reset_to_use then
                    if vim.fn.tabpagenr("$") > 1 then
                        -- Multiple tabs: close current tab and let resession create a new one
                        vim.cmd("tabclose")
                        resession.load(final_session_name, { attach = true, reset = false })
                    else
                        -- Only one tab: use reset = true to load in current tab
                        resession.load(final_session_name, { attach = true, reset = true })
                    end
                else
                    resession.load(final_session_name, { attach = true, reset = reset_to_use })
                end
            else
                resession.detach()
                if close_everything_when_no_session then
                    util.close_everything()
                else
                    -- When switching to a project without a session, close all windows in current tab
                    -- and create an empty buffer
                    vim.cmd("only")
                    local scratch = vim.api.nvim_create_buf(false, true)
                    vim.bo[scratch].bufhidden = "wipe"
                    vim.api.nvim_win_set_buf(0, scratch)
                    vim.bo[scratch].buftype = ""
                end
            end
        end,
    }
end

--+- Define Pickers -----------------------------------------+
---@class snacks.picker.Config
local picker_commands = {
    layout = "vscode",
    matcher = {
        frecency = true,
    },
}
---@class snacks.picker.Config
local picker_command_history = {
    preview = "none",
}
---@class snacks.picker.Config
local picker_notifications = {}

---@class snacks.picker.Config
local picker_grep = {
    hidden = true,
    layout = { preset = "dropdown" },
    layouts = {
        dropdown = {
            layout = {
                width = 0.8,
                max_width = 160,
            },
        },
    },
    matcher = {
        cwd_bonus = true,
        frecency = true,
    },
    actions = require("trouble.sources.snacks").actions,
    win = {
        input = {
            keys = {
                ["<c-t>"] = { "trouble_open", mode = { "n", "i" } },
            },
        },
    },
}
---@class snacks.picker.Config
local picker_man = {
    matcher = {
        frecency = true,
    },
}

-- Create different picker configurations for different use cases
---@class snacks.picker.Config
local picker_projects_dashboard = create_projects_picker_config({
    should_reset = true,
    confirm_non_tab_sessions = false,
    close_everything_when_no_session = true,
})

---@class snacks.picker.Config
local picker_projects_keymap = create_projects_picker_config({
    should_reset = false,
    confirm_non_tab_sessions = true,
    close_everything_when_no_session = false,
})

---@class snacks.picker.Config
local picker_smart = {
    layout = { preset = "dropdown" },
    matcher = {
        cwd_bonus = true,
    },
    actions = require("trouble.sources.snacks").actions,
    win = {
        input = {
            keys = {
                ["<c-t>"] = { "trouble_open", mode = { "n", "i" } },
            },
        },
    },
}
---@class snacks.picker.Config
local picker_workspace_symbols = {
    tree = true,
    matcher = {
        frecency = true,
        smartcase = true,
        ignorecase = false,
        filename_bonus = false,
        file_pos = false,
    },
}

--+- Configure Pickers --------------------------------------+
-- stylua: ignore start
-- vim.keymap.set({ "n" }, "gs", function() Snacks.picker.lsp_workspace_symbols(picker_workspace_symbols) end, { noremap = true, silent = true, desc = "Workspace Symbols" })

vim.keymap.set({ "n", "v" }, "<leader>vk", function() Snacks.picker.commands(picker_commands) end, { noremap = true, silent = true, desc = "Commands" })
vim.keymap.set({ "n", "v" }, "<leader>vK", function() Snacks.picker.command_history(picker_command_history) end, { noremap = true, silent = true, desc = "Command History" })
vim.keymap.set({ "n", "v" }, "<leader>vln", function() Snacks.picker.notifications(picker_notifications) end, { noremap = true, silent = true, desc = "List Notifications" })

vim.keymap.set({ "n", "v" }, "<leader>fa", function() Snacks.picker.grep(picker_grep) end, { noremap = true, silent = true, desc = "Find All (Grep)" })
vim.keymap.set({ "n", "v" }, "<leader>fm", function() Snacks.picker.man(picker_man) end, { noremap = true, silent = true, desc = "Find Man Page" })
vim.keymap.set({ "n", "v" }, "<leader>fr", function() Snacks.picker.resume() end, { noremap = true, silent = true, desc = "Finder Resume" })
vim.keymap.set({ "n", "v" }, "<leader>fh", function() Snacks.picker.help() end, { noremap = true, silent = true, desc = "Find Help" })
vim.keymap.set({ "n", "v" }, "<leader>fi", function() Snacks.picker.highlights() end, { noremap = true, silent = true, desc = "Find Highlights" })
vim.keymap.set({ "n", "v" }, "<leader>fk", function() Snacks.picker.keymaps() end, { noremap = true, silent = true, desc = "Find Keymap" })
vim.keymap.set({ "n", "v" }, "<leader>fp", function() Snacks.picker() end, { noremap = true, silent = true, desc = "Find Picker" })

vim.keymap.set({ "n", "v" }, "<leader>gb", function() Snacks.picker.git_branches() end, { noremap = true, silent = true, desc = "Git Branches" })
vim.keymap.set({ "n", "v" }, "<leader>of", function() Snacks.picker.smart(picker_smart) end, { noremap = true, silent = true, desc = "Open File" })
vim.keymap.set({ "n", "v" }, "<leader>op", function() Snacks.picker.projects(picker_projects_keymap) end, { noremap = true, silent = true, desc = "Open Project" })
-- stylua: ignore end

return {
    enabled = true,
    ui_select = true,
    formatters = {
        file = {
            filename_first = true,
        },
    },
    layout = { cycle = true, preset = "custom_vertical" },
    layouts = {
        custom_vertical = {
            layout = {
                backdrop = false,
                width = 0.8,
                min_width = 80,
                max_width = 120,
                height = 0.8,
                min_height = 30,
                box = "vertical",
                border = "rounded",
                title = "{title} {live} {flags}",
                title_pos = "center",
                { win = "input", height = 1, border = "bottom" },
                { win = "list", border = "none", height = 0.4 },
                { win = "preview", title = "{preview}", border = "top" },
            },
        },
    },
    actions = { require("trouble.sources.snacks").actions },
    win = {
        input = {
            b = {
                -- buffer local variables
            },
            keys = {
                ["<esc>"] = { "close", mode = { "n", "i" } },
                ["<c-space>"] = { "select", mode = { "i", "n" } },

                ["<tab>"] = { "list_down", mode = { "i", "n" } },
                ["<s-tab>"] = { "list_up", mode = { "i", "n" } },
                ["<c-j>"] = { "list_down", mode = { "i", "n" } },
                ["<c-k>"] = { "list_up", mode = { "i", "n" } },

                ["<c-v>"] = { "edit_split", mode = { "i", "n" } },
                ["<c-b>"] = { "edit_vsplit", mode = { "i", "n" } },
                ["<c-t>"] = { "trouble_open", mode = { "n", "i" } }, -- for some reason, refuses to work "globally"

                -- ["<c-u>"] = { "list_scroll_up", mode = { "i", "n" } },
                -- ["<c-d>"] = { "list_scroll_down", mode = { "i", "n" } },
                -- ["}"] = { "preview_scroll_down", mode = { "i", "n" } },
                -- ["{"] = { "preview_scroll_up", mode = { "i", "n" } },

                ["{{"] = { "list_scroll_up", mode = { "i", "n" } },
                ["}}"] = { "list_scroll_down", mode = { "i", "n" } },
                ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
                ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
            },
        },
    },
}
