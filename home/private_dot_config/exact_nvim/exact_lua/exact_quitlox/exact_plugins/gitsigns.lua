-- +---------------------------------------------------------+
-- | lewis6991/gitsigns.nvim: Git Gutter                     |
-- +---------------------------------------------------------+

local function on_attach(bufnr)
    local gs = require("gitsigns")

    local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    local function next_hunk()
        -- stylua: ignore
        if vim.wo.diff then return "]h" end
        vim.schedule(function()
            gs.next_hunk()
        end)
        return "<Ignore>"
    end

    local function prev_hunk()
        -- stylua: ignore
        if vim.wo.diff then return "[h" end
        vim.schedule(function()
            gs.prev_hunk()
        end)
        return "<Ignore>"
    end

    map("n", "]h", next_hunk, { expr = true, desc = "Hunk Next" })
    map("n", "[h", prev_hunk, { expr = true, desc = "Hunk Prev" })

    -- Actions
    -- stylua: ignore start
    map("n", "<leader>hs", gs.stage_hunk, { desc = "Hunk Stage" })
    map("n", "<leader>hr", gs.reset_hunk, { desc = "Hunk Reset" })
    map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Hunk Stage" })
    map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Hunk Reset" })
    -- stylua: ignore end

    -- stylua: ignore start
    map("n", "<leader>ga", gs.stage_buffer, { desc = "Stage Buffer" })
    -- stylua: ignore end

    -- stylua: ignore start
    map("n", "<leader>hS", gs.stage_buffer, { desc = "Hunk Stage Buffer" })
    map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Hunk Reset" })
    map("n", "<leader>hR", gs.reset_buffer, { desc = "Hunk Reset Buffer" })
    map("n", "<leader>hp", gs.preview_hunk, { desc = "Hunk Preview" })
    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Hunk Blame" })
    map("n", "<leader>Tb", gs.toggle_current_line_blame, { desc = "Toggle Blame" })
    map("n", "<leader>hd", gs.diffthis, { desc = "Hunk Diff" })
    map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = "Hunk Diff Buffer" })
    map("n", "<leader>htd", gs.toggle_deleted, { desc = "Toggle Deleted" })
    map("n", "<leader>hq", "<cmd>Gitsigns setqflist<cr>", { desc = "Git Quickfix" })
    -- stylua: ignore end

    -- Whickey
    require("which-key").add({
        { "<leader>g", group = "Git" },
        { "<leader>gh", group = "Hunk" },
    })

    -- Text object
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
end

--+- Toggle -------------------------------------------------+
vim.g.toggle_gitsigns = true

Snacks.toggle.new({
    name = "Git Blame",
    get = function()
        return vim.g.toggle_gitsigns
    end,
    set = function(state)
        require("gitsigns").toggle_current_line_blame(state)
        vim.g.toggle_gitsigns = state
    end,
})

--+- Setup --------------------------------------------------+
require("gitsigns").setup({
    trouble = false,
    on_attach = function(bufnr)
        -- Buggy on Jinja files
        if vim.api.nvim_buf_get_name(bufnr):match("jinja") then
            return false
        end
        return on_attach(bufnr)
    end,
})

--+- Integration: Scrollbar ---------------------------------+
local success, mod = pcall(require, "scrollbar.handlers.gitsigns")
if success then
    mod.setup()
end

--+- Integration: Resession ---------------------------------+
local success, resession = pcall(require, "resession")
if success then
    resession.add_hook("post_load", function()
        local tabpage = vim.api.nvim_get_current_tabpage()
        local windows = vim.api.nvim_tabpage_list_wins(tabpage)

        -- Loop over open editor buffers (active windows only) and attach gitsigns
        for _, win in ipairs(windows) do
            local bufnr = vim.api.nvim_win_get_buf(win)
            -- Only attach to valid and loaded buffers
            if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr) then
                pcall(require("gitsigns").attach, bufnr)
            end
        end
    end)
end
