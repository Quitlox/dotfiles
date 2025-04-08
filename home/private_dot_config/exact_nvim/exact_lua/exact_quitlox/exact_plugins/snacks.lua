-- +---------------------------------------------------------+
-- | folke/snacks.nvim                                       |
-- +---------------------------------------------------------+

require("snacks").setup({
    -- TODO: This isn't working yet
    styles = {
        my_compact = {
            style = "compact",
            wo = {
                wrap = true,
            },
        },
    },

    init = { enabled = true },
    bigfile = { enabled = true, notify = true },
    image = {
        enabled = vim.fn.has("wsl") ~= 1,
        doc = { inline = false, float = true, conceal = true },
        math = { enabled = true, latex = { font_size = "Large" } },
    },
    notifier = {
        enabled = true,
        style = "my_compact",
        icons = {
            error = " ",
            warn = " ",
            info = " ",
            debug = " ",
            trace = " ",
        },
    },
    picker = {
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
    },
    profiler = { enabled = true },
    scratch = { enabled = true },
    scroll = { enabled = (vim.fn.exists("g:neovide") == 0) },
    statuscolumn = { enabled = true, left = { "mark", "sign" }, right = { "fold", "git" } },
    terminal = { enabled = true },
    toggle = { enabled = true },
    quickfile = { enabled = true, exclude = { "latex" } },
})

-- +---------------------------------------------------------+
-- | snacks.nvim: Picker                                     |
-- +---------------------------------------------------------+

--+- Define Pickers -----------------------------------------+
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

---@class snacks.picker.Config
local picker_smart = {
    layout = "dropdown",
}

--+- Configure Pickers --------------------------------------+
-- stylua: ignore start
vim.keymap.set({ "n" }, "gs", function() Snacks.picker.lsp_workspace_symbols(picker_workspace_symbols) end, { noremap = true, silent = true, desc = "Workspace Symbols" })

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

Snacks.config.style("lazygit", {
    keys = {
        ["`"] = "hide",
    },
})

-- Tab-local Terminals ------------------------------------+

-- Copy of the equalize function from snacks.lua, but with the only change
-- being the use of vim.api.nvim_tabpage_list_wins instead of
-- vim.api.nvim_list_wins. This is done to make the terminal windows equalize
-- correctly.
local mod_snacks_win = require("snacks.win")
function mod_snacks_win:equalize()
    if self:is_floating() then
        return
    end
    local curr_tab_page = vim.api.nvim_win_get_tabpage(self.win)
    local all = vim.tbl_filter(
        function(win)
            return vim.w[win].snacks_win and vim.w[win].snacks_win.relative == self.opts.relative and vim.w[win].snacks_win.position == self.opts.position
        end,
        vim.api.nvim_tabpage_list_wins(curr_tab_page) -- NOTE: <- this is the only change
    )
    if #all <= 1 then
        return
    end
    local vertical = self.opts.position == "left" or self.opts.position == "right"
    local parent_size = self:parent_size()[vertical and "height" or "width"]
    local size = math.floor(parent_size / #all)
    for _, win in ipairs(all) do
        vim.api.nvim_win_call(win, function()
            vim.cmd(("%s resize %s"):format(vertical and "horizontal" or "vertical", size))
        end)
    end
end

local function toggle_terminal()
    -- Lazygit: magic terminal number 9
    if vim.v.count1 == 9 then
        return Snacks.lazygit.open()
    end

    -- Add current tab as context for tab-local terminals, such that terminal
    -- 1 in tab 1 has a different id as terminal 1 in tab 2.
    local env = { tab_page = vim.api.nvim_get_current_tabpage() }

    -- Parameters for the window of the terminal (default values)
    -- The way that snacks opens windows, is by having a few simple parameters
    -- that are translated into a window configuration. Unfortunately, the
    -- translation that snacks.terminal does, does not produce the desired
    -- tab-local behaviour. By default, opening a terminal window in a tab
    -- while another terminal window is open in another tab, will open the new
    -- terminal window in the old tab.
    local parent = 0
    local relative = "editor" -- default, to be overwritten
    local position = "bottom" -- default, to be overwritten
    local vertical = false -- default, to be overwritten

    -- To override this behaviour, we take matters into our own hands and
    -- translate the "desired" parameters into the "translated" parameters
    -- ourselves. By providing all parameters directly, we bypass the default
    -- translation of parameters.

    -- If we open a new terminal window while another terminal window is open
    -- in the current tab, we need to adjust how we open the new terminal, as
    -- we want to open it as a split of the existing terminal window. We search
    -- for such a window and set it as our parent window.

    -- This snippet is taken from snacks.lua, but altered to account for
    -- tab-local terminals, i.e. only windows in the current tab are
    -- considered.
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.w[win].snacks_win and vim.w[win].snacks_win.relative == relative and vim.w[win].snacks_win.position == position then
            parent = win
            relative = "win"
            position = vertical and "bottom" or "right"
            vertical = not vertical
            break
        end
    end

    -- if no other terminal windows are open in the current tab, we just wish
    -- to open the terminal window at the bottom of the editor. We do need to
    -- override the `parent` manually, otherwise we get the default behaviour
    -- of snacks.
    if parent == 0 then
        parent = vim.api.nvim_get_current_win()
    end

    -- Finally, open the terminal window
    local terminal_win = Snacks.terminal.toggle(nil, { env = env, win = { win = parent, relative = relative, position = position, vertical = vertical } })

    -- Only if the terminal is being opened
    if terminal_win:valid() then
        -- Because we bypassed the translation of parameters, the terminal window
        -- now has the "translated" parameters instead of the "desired"
        -- parameters. We therefore override the parameters back to the "desired"
        -- ones (that produce the wrong behaviour). We do this, as otherwise
        -- snacks.win does not equalize the terminal windows correctly (as it does
        -- not see them as equal).
        terminal_win.opts.position = "bottom"
        terminal_win.opts.relative = "editor"
        vim.w[terminal_win.win].snacks_win = {
            id = terminal_win.id,
            position = "bottom",
            relative = "editor",
        }

        -- Bit djanky, but now we equalize _again_ with the proper parameters
        vim.schedule(function()
            terminal_win:equalize()
        end)
    end
end

local function toggle_terminal_2()
    -- Lazygit: magic terminal number 9
    if vim.v.count1 == 9 then
        return Snacks.lazygit.open()
    end

    -- Add current tab as context for tab-local terminals, such that terminal
    -- 1 in tab 1 has a different id as terminal 1 in tab 2.
    local env = { tab_page = vim.api.nvim_get_current_tabpage() }
    Snacks.terminal.toggle(nil, { env = env })
end

-- Mode-dependent background ------------------------------+
-- Change the background color of the terminal window when entering and leaving
-- the terminal.
vim.api.nvim_create_autocmd({ "TermEnter", "TermLeave" }, {
    group = vim.api.nvim_create_augroup("MyTerminalBackground", { clear = true }),
    callback = function(args)
        local event = args.event
        local catppuccin_color_utils = require("catppuccin.utils.colors")
        local catppuccin_pallete = require("catppuccin.palettes").get_palette()

        if event == "TermLeave" then
            local curr_win = vim.api.nvim_get_current_win()
            if vim.w[curr_win].snacks_win then
                local ns = vim.api.nvim_create_namespace("snacks_terminal_" .. vim.w[curr_win].snacks_win.id)
                vim.api.nvim_set_hl(ns, "Normal", { bg = catppuccin_color_utils.darken(catppuccin_pallete.surface2, 0.3, catppuccin_pallete.base) })
                vim.api.nvim_set_hl(ns, "Winbar", { bg = catppuccin_pallete.crust })
                vim.api.nvim_set_hl(ns, "WinbarNC", { bg = catppuccin_pallete.crust })
                vim.api.nvim_win_set_hl_ns(curr_win, ns)
            end
        end

        if event == "TermEnter" then
            local curr_win = vim.api.nvim_get_current_win()
            if vim.w[curr_win].snacks_win then
                local ns = vim.api.nvim_create_namespace("snacks_terminal_" .. vim.w[curr_win].snacks_win.id)
                vim.api.nvim_set_hl(ns, "Normal", { link = "NormalFloat" })
                vim.api.nvim_win_set_hl_ns(curr_win, ns)
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
vim.keymap.set("n", [[`]], toggle_terminal_2, { silent = true, desc = "Toggle Terminal" })
vim.keymap.set("v", [[`]], toggle_terminal_2, { silent = true, desc = "Toggle Terminal" })
vim.keymap.set("t", [[`]], toggle_terminal_2, { silent = true, desc = "Toggle Terminal" })

vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { silent = true })
vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { silent = true })

-- +---------------------------------------------------------+
-- | snacks.nvim: Toggle                                     |
-- +---------------------------------------------------------+

Snacks.toggle.treesitter():map("<leader>Tt")
Snacks.toggle.inlay_hints():map("<leader>Th")
Snacks.toggle.diagnostics():map("<leader>Td")
