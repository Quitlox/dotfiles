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
        if vim.wo.diff then return "]h" end
        vim.schedule(function() gs.next_hunk() end)
        return "<Ignore>"
    end

    local function prev_hunk()
        if vim.wo.diff then return "[h" end
        vim.schedule(function() gs.prev_hunk() end)
        return "<Ignore>"
    end

    map("n", "]h", next_hunk, { expr = true, desc = "Hunk Next" })
    map("n", "[h", prev_hunk, { expr = true, desc = "Hunk Prev" })

    -- Actions
    map("n", "<leader>hs", gs.stage_hunk, { desc = "Hunk Stage" })
    map("n", "<leader>hr", gs.reset_hunk, { desc = "Hunk Reset" })
    map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Hunk Stage" })
    map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Hunk Reset" })

    map("n", "<leader>hS", gs.stage_buffer, { desc = "Hunk Stage Buffer" })
    map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Hunk Reset" })
    map("n", "<leader>hR", gs.reset_buffer, { desc = "Hunk Reset Buffer" })
    map("n", "<leader>hp", gs.preview_hunk, { desc = "Hunk Preview" })
    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Hunk Blame" })
    map("n", "<leader>Tb", gs.toggle_current_line_blame, { desc = "Toggle Blame" })
    map("n", "<leader>hd", gs.diffthis, { desc = "Hunk Diff" })
    map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = "Hunk Diff Buffer" })
    map("n", "<leader>htd", gs.toggle_deleted, { desc = "Toggle Deleted" })
    map("n", "<leader>glc", "<cmd>Gitsigns setqflist<cr>", { desc = "Git Quickfix" })

    -- Whickey
    require("which-key").add({
        { "<leader>g", group = "Git" },
        { "<leader>gl", group = "List" },
        { "<leader>gh", group = "Hunk" },
    })

    -- Text object
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
end

--+- Setup --------------------------------------------------+
require("gitsigns").setup({
    on_attach = on_attach,
    trouble = false,
    _signs_staged_enable = true,
})

--+- Integration --------------------------------------------+
require("scrollbar.handlers.gitsigns").setup()
