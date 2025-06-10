-- +---------------------------------------------------------+
-- | folke/snacks.nvim                                       |
-- +---------------------------------------------------------+

-- Options for snacks that only have simple configurations
local simple_snack_opts = {
    bigfile = { enabled = true, notify = true },
    input = { enabled = true },
    profiler = { enabled = true },
    scratch = { enabled = true },
    scroll = { enabled = (vim.fn.exists("g:neovide") == 0) },
    statuscolumn = { enabled = true, left = { "mark", "sign" }, right = { "fold", "git" } },
    terminal = { enabled = true },
    toggle = { enabled = true },
    quickfile = { enabled = true, exclude = { "latex" } },
}

-- +---------------------------------------------------------+
-- | snacks.nvim: Image                                      |
-- +---------------------------------------------------------+

local image_opts = {
    enabled = vim.fn.has("wsl") ~= 1,
    doc = { inline = false, float = true, conceal = true },
    math = { enabled = true, latex = { font_size = "Large" } },
}

-- +---------------------------------------------------------+
-- | snacks.nvim: Notifier                                   |
-- +---------------------------------------------------------+

local notifier_opts = {
    enabled = true,
    icons = {
        error = " ",
        warn = " ",
        info = " ",
        debug = " ",
        trace = " ",
    },
}

-- +---------------------------------------------------------+
-- | snacks.nvim: Styles                                     |
-- +---------------------------------------------------------+

local styles_opts = {
    notification = {
        wo = {
            -- NOTE: I added this to make the helper window of `scissors.nvim` look nice.
            -- Check if this is desired for all notfications.
            wrap = true,
        },
    },
}

-- +---------------------------------------------------------+
-- | snacks.nvim: Picker                                     |
-- +---------------------------------------------------------+

local picker_opts = {
    enabled = true,
    ui_select = true,
    formatters = {
        file = {
            filename_first = true,
        },
    },
    layout = "custom_vertical",
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
    actions = { vim.tbl_deep_extend("force", {}, require("trouble.sources.snacks").actions) },
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
                ["<c-t>"] = { "trouble_open", mode = { "n", "i" } },

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
    layout = "dropdown",
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
}
---@class snacks.picker.Config
local picker_man = {
    matcher = {
        frecency = true,
    },
}
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
            local util = require("quitlox.util.session")

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
    layout = "dropdown",
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
vim.keymap.set({ "n", "v" }, "<leader>vd", function() vim.notify('noop', 'info') end, { noremap = true, silent = true, desc = "List Notifications" })

vim.keymap.set({ "n", "v" }, "<leader>fa", function() Snacks.picker.grep(picker_grep) end, { noremap = true, silent = true, desc = "Find All (Grep)" })
vim.keymap.set({ "n", "v" }, "<leader>fm", function() Snacks.picker.man(picker_man) end, { noremap = true, silent = true, desc = "Find Man Page" })
vim.keymap.set({ "n", "v" }, "<leader>fr", function() Snacks.picker.resume() end, { noremap = true, silent = true, desc = "Finder Resume" })
vim.keymap.set({ "n", "v" }, "<leader>fh", function() Snacks.picker.help() end, { noremap = true, silent = true, desc = "Find Help" })
vim.keymap.set({ "n", "v" }, "<leader>fi", function() Snacks.picker.highlights() end, { noremap = true, silent = true, desc = "Find Highlights" })
vim.keymap.set({ "n", "v" }, "<leader>fk", function() Snacks.picker.keymaps() end, { noremap = true, silent = true, desc = "Find Keymap" })

vim.keymap.set({ "n", "v" }, "<leader>gb", function() Snacks.picker.git_branches() end, { noremap = true, silent = true, desc = "Git Branches" })
vim.keymap.set({ "n", "v" }, "<leader>of", function() Snacks.picker.smart(picker_smart) end, { noremap = true, silent = true, desc = "Open File" })
vim.keymap.set({ "n", "v" }, "<leader>op", function() Snacks.picker.projects(picker_projects_keymap) end, { noremap = true, silent = true, desc = "Open Project" })
-- stylua: ignore end

-- +---------------------------------------------------------+
-- | snacks.nvim: Profile                                    |
-- +---------------------------------------------------------+

vim.keymap.set("n", "<leader>ps", require("snacks").profiler.scratch, { desc = "Profiler Scratch Buffer" })

-- Toggle the profiler
Snacks.toggle.profiler():map("<leader>pp")
-- Toggle the profiler highlights
Snacks.toggle.profiler_highlights():map("<leader>ph")

require("which-key").add({
    { "<leader>p", group = "Profile" },
})

-- +---------------------------------------------------------+
-- | snacks.nvim: Terminal                                   |
-- +---------------------------------------------------------+

-- Terminal opts ------------------------------------------+
---@class snacks.terminal.Config
local terminal_opts = {
    auto_insert = false,
    auto_close = true,
    win = {
        keys = {
            -- Override the default 'i' key to enter insert mode in both terminal and shell
            i = function(self)
                -- Send 'i' to shell to enter vi insert mode, then enter terminal insert mode
                vim.api.nvim_feedkeys("i", "n", false)
                vim.cmd.startinsert()
            end,
            -- Override 'a' key to append in both terminal and shell
            a = function(self)
                -- Send 'a' to shell to enter vi insert mode (append), then enter terminal insert mode
                vim.api.nvim_feedkeys("a", "n", false)
                vim.cmd.startinsert()
            end,
            -- Override 'A' key to append at end of line in both terminal and shell
            A = function(self)
                -- Send 'A' to shell to enter vi insert mode (append at end), then enter terminal insert mode
                vim.api.nvim_feedkeys("A", "n", false)
                vim.cmd.startinsert()
            end,
        },
    },
}

-- Tab-local Terminals ------------------------------------+
Snacks.config.style("lazygit", {
    keys = {
        ["`"] = "hide",
    },
})

-- Tab-local Terminals ------------------------------------+

local function toggle_terminal()
    -- Lazygit: magic terminal number 9
    if vim.v.count1 == 9 then
        return Snacks.lazygit.open()
    end

    -- Add current tab as context for tab-local terminals, such that terminal
    -- 1 in tab 1 has a different id as terminal 1 in tab 2.
    local env = { tab_page = vim.api.nvim_get_current_tabpage() }
    Snacks.terminal.toggle(nil, { env = env })
end

-- Terminal mode persistence & background -----------------+
-- Handle mode persistence and mode-based background colors

local function update_terminal_background(win, buf, mode)
    if vim.w[win].snacks_win then
        local catppuccin_color_utils = require("catppuccin.utils.colors")
        local catppuccin_pallete = require("catppuccin.palettes").get_palette()
        local ns = vim.api.nvim_create_namespace("snacks_terminal_" .. vim.w[win].snacks_win.id)

        if mode == "t" then
            -- Terminal insert mode - normal background
            vim.api.nvim_set_hl(ns, "Normal", { link = "NormalFloat" })
        else
            -- Terminal normal mode - darker background
            vim.api.nvim_set_hl(ns, "Normal", { bg = catppuccin_color_utils.darken(catppuccin_pallete.surface2, 0.3, catppuccin_pallete.base) })
            vim.api.nvim_set_hl(ns, "Winbar", { bg = catppuccin_pallete.crust })
            vim.api.nvim_set_hl(ns, "WinbarNC", { bg = catppuccin_pallete.crust })
        end
        vim.api.nvim_win_set_hl_ns(win, ns)
    end
end

vim.api.nvim_create_autocmd({ "WinLeave" }, {
    group = vim.api.nvim_create_augroup("MyTerminalBehavior", { clear = true }),
    callback = function(args)
        local curr_win = vim.api.nvim_get_current_win()
        local curr_buf = vim.api.nvim_get_current_buf()

        -- Only handle snacks terminal windows
        local is_snacks_terminal = vim.w[curr_win].snacks_win and vim.bo[curr_buf].filetype == "snacks_terminal"

        if is_snacks_terminal then
            -- Store the current mode state when leaving terminal window
            local mode = vim.fn.mode()
            vim.b[curr_buf].terminal_was_in_insert = mode == "t"
        end
    end,
})

vim.api.nvim_create_autocmd({ "WinEnter" }, {
    group = vim.api.nvim_create_augroup("MyTerminalModeRestore", { clear = true }),
    callback = function(args)
        local curr_win = vim.api.nvim_get_current_win()
        local curr_buf = vim.api.nvim_get_current_buf()

        -- Only handle snacks terminal windows
        local is_snacks_terminal = vim.w[curr_win].snacks_win and vim.bo[curr_buf].filetype == "snacks_terminal"

        if is_snacks_terminal then
            -- Restore the mode state when entering terminal
            local should_insert = vim.b[curr_buf].terminal_was_in_insert
            if should_insert then
                vim.schedule(function()
                    vim.cmd.startinsert()
                    -- Update background for insert mode
                    update_terminal_background(curr_win, curr_buf, "t")
                end)
            else
                -- Update background for normal mode
                update_terminal_background(curr_win, curr_buf, "n")
            end
        end
    end,
})

-- Handle mode changes within terminal (like Esc Esc and i/a/A)
vim.api.nvim_create_autocmd({ "TermEnter", "TermLeave" }, {
    group = vim.api.nvim_create_augroup("MyTerminalModeChange", { clear = true }),
    callback = function(args)
        local event = args.event
        local curr_win = vim.api.nvim_get_current_win()
        local curr_buf = vim.api.nvim_get_current_buf()

        -- Only handle snacks terminal windows
        local is_snacks_terminal = vim.w[curr_win].snacks_win and vim.bo[curr_buf].filetype == "snacks_terminal"

        if is_snacks_terminal then
            if event == "TermEnter" then
                -- Entering terminal insert mode
                update_terminal_background(curr_win, curr_buf, "t")
            elseif event == "TermLeave" then
                -- Leaving terminal insert mode (going to normal mode)
                update_terminal_background(curr_win, curr_buf, "n")
            end
        end
    end,
})

-- Close on Exit ----------- ------------------------------+
vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("MyTerminalCloseOnExit", { clear = true }),
    callback = function(args)
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.w[win].snacks_win then
                vim.api.nvim_win_close(win, true)
            end
        end
    end,
})

-- Keymaps ------------------------------------------------+
vim.keymap.set({ "n", "v", "t" }, [[`]], toggle_terminal, { silent = true, desc = "Toggle Terminal" })
vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { silent = true })
vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { silent = true })

-- +---------------------------------------------------------+
-- | snacks.nvim: Toggle                                     |
-- +---------------------------------------------------------+

Snacks.toggle.treesitter():map("<leader>Tt")
Snacks.toggle.inlay_hints():map("<leader>Th")
Snacks.toggle.diagnostics():map("<leader>Td")

-- +---------------------------------------------------------+
-- | snacks.nvim: Dashboard                                  |
-- +---------------------------------------------------------+

local dashboard_opts = {
    enabled = true,
    sections = {
        {
            section = "terminal",
            cmd = "chafa ~/Pictures/Wallpapers/dark_forest1.jpg --format symbols --symbols vhalf --size 60x17 --stretch; sleep .1",
            height = 17,
            padding = 1,
        },
        {
            pane = 2,
            { section = "keys", gap = 1, padding = 1 },
        },
    },
    preset = {
        keys = {
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
                icon = " ",
                key = "p",
                desc = "Project",
                action = function()
                    Snacks.picker.projects(picker_projects_dashboard)
                end,
            },

            {
                icon = " ",
                key = "s",
                desc = "Select Session",
                action = function()
                    local sessions = require("resession").list()
                    if #sessions == 0 then
                        vim.notify("No sessions found", vim.log.levels.INFO)
                        return
                    end
                    vim.ui.select(sessions, {
                        prompt = "Select session:",
                        format_item = function(session)
                            return session
                        end,
                    }, function(session)
                        if session then
                            require("resession").load(session, { attach = true, reset = true })
                        end
                    end)
                end,
            },
            {
                icon = " ",
                key = "l",
                desc = "Last Session",
                action = function()
                    require("resession").load("last", { silence_errors = true })
                end,
            },
            {
                icon = " ",
                key = "c",
                desc = "Config",
                action = function()
                    local resession = require("resession")
                    local util = require("quitlox.util.session")
                    local config_dir = vim.fn.expand("~/.config/nvim")

                    -- Save current session
                    resession.save_tab(util.get_session_name(), { notify = false, attach = true })

                    -- Navigate to config directory
                    vim.cmd("tcd " .. vim.fn.fnameescape(config_dir))

                    -- Load config session if it exists
                    local config_session_name = util.get_session_name(config_dir)
                    local resession_util = require("resession.util")
                    local session_file = resession_util.get_session_file(config_session_name)
                    local session_basename = vim.fs.basename(session_file)
                    local final_session_name = session_basename:gsub("%.json$", "")

                    if vim.tbl_contains(resession.list(), final_session_name) then
                        resession.load(final_session_name, { attach = true, reset = true })
                    else
                        resession.detach()
                        util.close_everything()
                    end

                    -- Open file picker in config directory
                    Snacks.dashboard.pick("files", { cwd = config_dir })
                end,
            },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
    },
}

-- +---------------------------------------------------------+
-- | snacks.nvim: Setup                                      |
-- +---------------------------------------------------------+

-- Collect all snack options and initialize
require("snacks").setup(vim.tbl_deep_extend("force", simple_snack_opts, {
    dashboard = dashboard_opts,
    image = image_opts,
    notifier = notifier_opts,
    picker = picker_opts,
    styles = styles_opts,
    terminal = terminal_opts,
}))
