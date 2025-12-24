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

    local function next_file()
        gs.setqflist("all", { open = false }, function()
            vim.schedule(function()
                local qf = vim.fn.getqflist()
                local cur_bufnr = vim.api.nvim_get_current_buf()
                local found = false
                for i, item in ipairs(qf) do
                    if found and item.bufnr ~= cur_bufnr then
                        vim.cmd("cc " .. i)
                        return
                    end
                    if item.bufnr == cur_bufnr then found = true end
                end
                for i, item in ipairs(qf) do
                    if item.bufnr ~= cur_bufnr then
                        vim.cmd("cc " .. i)
                        return
                    end
                end
            end)
        end)
    end

    local function prev_file()
        gs.setqflist("all", { open = false }, function()
            vim.schedule(function()
                local qf = vim.fn.getqflist()
                local cur_bufnr = vim.api.nvim_get_current_buf()
                local found = false
                for i = #qf, 1, -1 do
                    if found and qf[i].bufnr ~= cur_bufnr then
                        vim.cmd("cc " .. i)
                        return
                    end
                    if qf[i].bufnr == cur_bufnr then found = true end
                end
                for i = #qf, 1, -1 do
                    if qf[i].bufnr ~= cur_bufnr then
                        vim.cmd("cc " .. i)
                        return
                    end
                end
            end)
        end)
    end

    -- Navigation
    map("n", "]h", next_hunk, { expr = true, desc = "Hunk Next" })
    map("n", "[h", prev_hunk, { expr = true, desc = "Hunk Prev" })

    -- Actions
    -- stylua: ignore start
    map("n", "<leader>ga", function() gs.stage_buffer(gs.refresh) end, { desc = "Stage Buffer" })
    map("n", "<leader>hs", function() gs.stage_hunk(nil, {}, gs.refresh) end, { desc = "Stage" })
    map("n", "<leader>hr", function() gs.reset_hunk(nil, {}, gs.refresh) end, { desc = "Reset" })
    map("n", "<leader>hu", function() gs.undo_stage_hunk(gs.refresh) end, { desc = "Undo Stage" })
    map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview" })
    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Blame" })
    map("n", "<leader>hd", gs.diffthis, { desc = "Diff" })
    map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = "Diff Buffer" })
    map("n", "<leader>htd", gs.toggle_deleted, { desc = "Toggle Deleted" })
    map("n", "<leader>hq", "<cmd>Gitsigns setqflist<cr>", { desc = "Quickfix" })
    map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }, {}, gs.refresh) end, { desc = "Stage" })
    map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }, {}, gs.refresh) end, { desc = "Reset" })
    -- stylua: ignore end

    -- Hydra mode: navigate and stage/reset hunks without leaving the which-key menu
    -- stylua: ignore start
    map("n", "<leader>hh", function() require("which-key").show({ keys = "<leader>h", loop = true }) end, { desc = "Hydra" })
    map("n", "<leader>hj", function() gs.nav_hunk("next", { target = "all" }) end, { desc = "Next Hunk" })
    map("n", "<leader>hk", function() gs.nav_hunk("prev", { target = "all" }) end, { desc = "Prev Hunk" })
    map("n", "<leader>hgg", function() gs.nav_hunk("first", { target = "all" }) end, { desc = "First Hunk" })
    map("n", "<leader>hG", function() gs.nav_hunk("last", { target = "all" }) end, { desc = "Last Hunk" })
    map("n", "<leader>hJ", "j", { desc = "Down" })
    map("n", "<leader>hK", "k", { desc = "Up" })
    map("n", "<leader>h<C-d>", "<C-d>", { desc = "Scroll Down" })
    map("n", "<leader>h<C-u>", "<C-u>", { desc = "Scroll Up" })
    map("n", "<leader>hgj", function() gs.nav_hunk("next", { target = "unstaged" }) end, { desc = "Next Unstaged" })
    map("n", "<leader>hgk", function() gs.nav_hunk("prev", { target = "unstaged" }) end, { desc = "Prev Unstaged" })
    map("n", "<leader>hgJ", function() gs.nav_hunk("next", { target = "staged" }) end, { desc = "Next Staged" })
    map("n", "<leader>hgK", function() gs.nav_hunk("prev", { target = "staged" }) end, { desc = "Prev Staged" })
    map("n", "<leader>h]", next_file, { desc = "Next File" })
    map("n", "<leader>h[", prev_file, { desc = "Prev File" })
    map("n", "<leader>hS", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line(".") }, {}, gs.refresh) end, { desc = "Stage Line" })
    map("n", "<leader>hR", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line(".") }, {}, gs.refresh) end, { desc = "Reset Line" })
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
vim.g.toggle_gitsigns_blame = false

Snacks.toggle
    .new({
        name = "Git Blame",
        get = function()
            return vim.g.toggle_gitsigns_blame
        end,
        set = function(state)
            require("gitsigns").toggle_current_line_blame(state)
            vim.g.toggle_gitsigns_blame = state
        end,
    })
    :map("yob")

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
