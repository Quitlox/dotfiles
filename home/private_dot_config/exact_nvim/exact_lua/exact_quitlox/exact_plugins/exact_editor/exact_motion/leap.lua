----------------------------------------------------------------------
--                               Leap                               --
----------------------------------------------------------------------
-- The all-in-one motion plugin for jumping anywhere on screen

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
            if lnum ~= cur_line then
                table.insert(targets, { pos = { lnum, 1 } })
            end
            lnum = lnum + increment
        end
    end
    -- Sort them by vertical screen distance from cursor.
    local cur_screen_row = vim.fn.screenpos(winid, cur_line, 1)["row"]
    local function screen_rows_from_cur(t)
        local t_screen_row = vim.fn.screenpos(winid, t.pos[1], t.pos[2])["row"]
        return math.abs(cur_screen_row - t_screen_row)
    end
    table.sort(targets, function(t1, t2)
        return screen_rows_from_cur(t1) < screen_rows_from_cur(t2)
    end)

    if #targets >= 1 then
        return targets
    end
end

local function leap_to_line_forward()
    local winid = vim.api.nvim_get_current_win()
    require("leap").leap({
        safe_labels = {},
        target_windows = { winid },
        targets = get_line_starts(winid),
    })
end
local function leap_to_line_backward()
    local winid = vim.api.nvim_get_current_win()
    require("leap").leap({
        safe_labels = {},
        target_windows = { winid },
        targets = get_line_starts(winid, true),
    })
end

return {
    "ggandor/leap.nvim",
    enabled = false,
    keys = {
        { "<leader><leader>j", leap_to_line_forward, desc = "which_key_ignore", mode = { "n", "v" } },
        { "<leader><leader>k", leap_to_line_backward, desc = "which_key_ignore", mode = { "n", "v" } },
    },
}
