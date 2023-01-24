----------------------------------------------------------------------
--                      Leap: Custom Functions                      --
----------------------------------------------------------------------

-- Require Leap
local leap_ok, leap = pcall(require, "leap")
if not leap_ok then return end

--- Generate targets for jumping to a line (like EasyMotion/Hop line-jump)
---@param winid The window id of the window for which to generate the targets
---@param backward Whether to jump forwards or backwards (true is backwards)
local function get_line_starts(winid, backward)
    local wininfo = vim.fn.getwininfo(winid)[1]
    local cur_line = vim.fn.line(".")

    local condition = function(lnum)
        if backward then
            return lnum >= wininfo.topline
        else
            return lnum <= wininfo.botline
        end
    end
    local increment = backward and -1 or 1

    -- Get targets.
    local targets = {}
    local lnum = cur_line
    while condition(lnum) do
        local fold_end = vim.fn.foldclosedend(lnum)
        -- Skip folded ranges.
        if fold_end ~= -1 then
            lnum = fold_end + increment
        else
            if lnum ~= cur_line then table.insert(targets, { pos = { lnum, 1 } }) end
            lnum = lnum + increment
        end
    end
    -- Sort them by vertical screen distance from cursor.
    local cur_screen_row = vim.fn.screenpos(winid, cur_line, 1)["row"]
    local function screen_rows_from_cur(t)
        local t_screen_row = vim.fn.screenpos(winid, t.pos[1], t.pos[2])["row"]
        return math.abs(cur_screen_row - t_screen_row)
    end
    table.sort(targets, function(t1, t2) return screen_rows_from_cur(t1) < screen_rows_from_cur(t2) end)

    if #targets >= 1 then return targets end
end

local function leap_to_line_forward()
    local winid = vim.api.nvim_get_current_win()
    leap.leap({
        safe_labels = {},
        target_windows = { winid },
        targets = get_line_starts(winid),
    })
end
local function leap_to_line_backward()
    local winid = vim.api.nvim_get_current_win()
    leap.leap({
        safe_labels = {},
        target_windows = { winid },
        targets = get_line_starts(winid, true),
    })
end

----------------------------------------------------------------------
--                               Leap                               --
----------------------------------------------------------------------
-- The all-in-one motion plugin for jumping anywhere on screen

import({ "leap", "which-key" }, function(modules)
    local leap = modules["leap"]
    local wk = modules["which-key"]

    leap.add_default_mappings()
    local winid = vim.api.nvim_get_current_win()

    local _mapping = { j = { leap_to_line_forward, "Jump Line Down" }, k = { leap_to_line_backward, "Jump Line Down" } }
    wk.register( _mapping, { prefix = "<leader><leader>", mode = "n" })
    wk.register( _mapping, { prefix = "<leader><leader>", mode = "v" })

    -- Highlights
    -- Colors taken from Hop.nvim
    -- https://github.com/phaazon/hop.nvim/blob/5901f0e7928d8561800e3ca228c17618b686c532/lua/hop/highlight.lua
    vim.api.nvim_set_hl(0, "LeapLabelPrimary", { fg = "#ff007c", bold = true })
    vim.api.nvim_set_hl(0, "LeapLabelSecondary", { fg = "#00dfff", bold = true })
    vim.api.nvim_set_hl(0, "LeapBackdrop", { bg = "Comment" })
end)

----------------------------------------------------------------------
--                               Flit                               --
----------------------------------------------------------------------
-- Extension to Leap similar to CleverF
-- Improves the functionality of f/F and t/T

import("flit", function(flit)
    flit.setup({
        keys = { f = "f", F = "F", t = "t", T = "T" },
        -- A string like "nv", "nvo", "o", etc.
        labeled_modes = "v",
        multiline = true,
        -- Like `leap`s similar argument (call-specific overrides).
        -- E.g.: opts = { equivalence_classes = {} }
        opts = {},
    })
end)

----------------------------------------------------------------------
--                           Leap Spooky                            --
----------------------------------------------------------------------
-- Extension to Leap for allowing to remotely perform actions

import("leap-spooky", function(spooky)
    spooky.setup({
        affixes = {
            -- These will generate mappings for all native text objects, like:
            -- (ir|ar|iR|aR|im|am|iM|aM){obj}.
            -- Special line objects will also be added, by repeating the affixes.
            -- E.g. `yrr<leap>` and `ymm<leap>` will yank a line in the current
            -- window.
            -- You can also use 'rest' & 'move' as mnemonics.
            remote = { window = "r", cross_window = "R" },
            magnetic = { window = "m", cross_window = "M" },
        },
        -- If this option is set to true, the yanked text will automatically be pasted
        -- at the cursor position if the unnamed register is in use.
        paste_on_remote_yank = false,
    })
end)
