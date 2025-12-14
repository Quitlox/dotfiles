-- +---------------------------------------------------------+
-- | snacks.nvim: Terminal                                   |
-- +---------------------------------------------------------+

--+- Workaround: Supress certain exit codes -----------------+
local notify_error = Snacks.notify.error
Snacks.notify.error = function(msg, ...)
    if type(msg) == "string" and msg:find("Terminal exited with code 127", 1, true) then
        return
    end
    return notify_error(msg, ...)
end

--+- Config -------------------------------------------------+
---@class snacks.terminal.Config
local terminal_opts = {
    auto_insert = false,
    auto_close = true,
    win = { style = "my_terminal" },
}

--+- Layout -------------------------------------------------+
Snacks.config.style("my_terminal", {
    keys = {
        term_win_j = { "<C-j>", "<cmd>wincmd j<cr>", mode = "t", expr = true },
        term_win_k = { "<C-k>", "<cmd>wincmd k<cr>", mode = "t", expr = true },
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
})

Snacks.config.style("my_lazygit", {
    keys = {
        ["`"] = "hide",
    },
})

Snacks.config.style("my_lazydocker", {
    keys = {
        ["`"] = "hide",
    },
})

--+- Behaviour ----------------------------------------------+
local function toggle_terminal()
    -- Lazygit: magic terminal number 9
    if vim.v.count1 == 9 then
        return Snacks.lazygit.open()
    end
    if vim.v.count1 == 8 then
        return Snacks.terminal("lazydocker", nil)
    end

    -- Add current tab as context for tab-local terminals, such that terminal
    -- 1 in tab 1 has a different id as terminal 1 in tab 2.
    local env = { tab_page = vim.api.nvim_get_current_tabpage() }
    Snacks.terminal.toggle(nil, { env = env })
end

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

vim.keymap.set({ "n", "v", "t" }, [[`]], toggle_terminal, { silent = true, desc = "Toggle Terminal" })

return terminal_opts
