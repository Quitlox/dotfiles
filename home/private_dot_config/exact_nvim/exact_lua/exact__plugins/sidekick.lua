-- +---------------------------------------------------------+
-- | folke/sidekic.nvim: Copilot Next Edit & Agent CLI       |
-- +---------------------------------------------------------+
vim.g.sidekick_nes = false

-- Pin the sidekick terminal's view to the bottom of the buffer *before*
-- the blur action's wincmd p moves focus away. Running this pin only via
-- ModeChanged after the fact is too late — Neovim has already repainted
-- the now-unfocused terminal window against Claude's old cursor position,
-- which lands the view in the middle of the redraw history.
---@param t sidekick.cli.Terminal
local function blur_and_pin(t)
    if t:is_focused() and t:win_valid() and t:buf_valid() then
        local line_count = vim.api.nvim_buf_line_count(t.buf)
        local height = vim.api.nvim_win_get_height(t.win)
        vim.api.nvim_win_set_cursor(t.win, { line_count, 0 })
        vim.api.nvim_win_call(t.win, function()
            vim.fn.winrestview({
                topline = math.max(1, line_count - height + 1),
                lnum = line_count,
                col = 0,
            })
        end)
    end
    t:blur()
end

require("sidekick").setup({
    cli = {
        win = {
            keys = {
                stopinsert = { "<c-o>", "stopinsert", mode = "t" }, -- enter normal mode
                win_p = { "<c-h>", blur_and_pin, mode = "t" },
            },
        },
    },
})

-- stylua: ignore start
vim.keymap.set("n", "<c-a>", function() if not require("sidekick").nes_jump_or_apply() then return "<Tab>" end end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })
vim.keymap.set("n", "<leader>aa", require("sidekick.cli").toggle, { desc = "Sidekick Toggle CLI" })
vim.keymap.set("n", "<leader>as", require("sidekick.cli").select, { desc = "Select CLI" })
vim.keymap.set({ "x", "n" }, "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end, { desc = "Send This" })
vim.keymap.set("x", "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end, { desc = "Send Visual Selection" })
vim.keymap.set({ "n", "x" }, "<leader>ap", require("sidekick.cli").prompt, { desc = "Sidekick Select Prompt" })
vim.keymap.set({ "n", "x", "i", "t" }, "<c-.>", require("sidekick.cli").focus, { desc = "Sidekick Switch Focus" })
-- vim.keymap.set("n", "<leader>ac", function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end, { desc = "Sidekick Toggle Claude" })
-- stylua: ignore end

require("which-key").add({
    { "<leader>a", group = "Agent/AI" },
})

-- Pin view to the bottom of the buffer when transitioning out of
-- terminal-job mode in a sidekick terminal. TUIs like Claude Code redraw
-- via the alternate screen, and Neovim stores every redraw as buffer
-- lines. Without this, leaving terminal mode lands the cursor wherever
-- Claude's cursor was, which looks like the view "jumps" up into the
-- redraw history. Jumping to end + `zb` keeps the most recent redraw
-- visible, matching what was on screen in terminal mode.
--
-- Using ModeChanged `t:*` catches both `<C-\><C-n>` (t -> nt in place) and
-- the `blur` keymap (t -> nt via wincmd p), while staying silent when the
-- user leaves the window from an already-normal-mode state (no mode
-- change fires), preserving whatever scroll position they had.
vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "t:*",
    group = vim.api.nvim_create_augroup("MySidekickPinView", { clear = true }),
    callback = function(args)
        if vim.bo[args.buf].filetype ~= "sidekick_terminal" then
            return
        end
        local buf = args.buf
        vim.defer_fn(function()
            if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].filetype ~= "sidekick_terminal" then
                return
            end
            local win = vim.fn.bufwinid(buf)
            if win ~= -1 then
                vim.api.nvim_win_call(win, function()
                    vim.cmd("normal! Gzb")
                end)
            end
        end, 10)
    end,
})

Snacks.toggle
    .new({
        name = "Next Edit Suggestion",
        get = function()
            local nes_enabled = vim.g.sidekick_nes ~= 0 and vim.g.sidekick_nes ~= false
            return nes_enabled
        end,
        set = function(state)
            if state then
                require("sidekick.nes").enable()
            else
                require("sidekick.nes").disable()
            end
        end,
    })
    :map("yoA")
