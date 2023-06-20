----------------------------------------------------------------------
--                          Git: Gitgutter                          --
----------------------------------------------------------------------
-- Shows git signs for line additions, changes and deletions in the gutter (next
-- to the line number column)

return {
    "lewis6991/gitsigns.nvim",
    version = "",
    event = "VeryLazy",
    config = function()
        local function on_attach(bufnr)
            local gs = require("gitsigns")
            local wk = require("which-key")

            ----------------------------------------
            -- Git Hunk Navigation
            ----------------------------------------

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

            vim.keymap.set("n", "]h", next_hunk, { expr = true, buffer = bufnr })
            vim.keymap.set("n", "[h", prev_hunk, { expr = true, buffer = bufnr })

            wk.register({
                ["[h"] = { "Next Change" },
                ["]h"] = { "Prev Change" },
            })

            ----------------------------------------
            -- Misc
            ----------------------------------------

            -- Git Blame
            wk.register({
                b = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Toggle git Blame" },
            }, { prefix = "<leader>T", buffer = bufnr })

            -- Git List
            wk.register({
                g = { name = "Git", l = { name = "List", c = { "<cmd>Gitsigns setqflist<cr>", "Git list Changes" } } },
            }, { prefix = "<leader>", buffer = bufnr })

            -- Hunk Actions (Line)
            local _mapping = {
                name = "Hunk",
                s = { "<cmd>Gitsigns stage_hunk<cr>", "Hunk Stage" },
                r = { "<cmd>Gitsigns reset_hunk<cr>", "Hunk Reset" },
            }
            wk.register(_mapping, { prefix = "<leader>h", mode = "n", buffer = bufnr })
            wk.register(_mapping, { prefix = "<leader>h", mode = "v", buffer = bufnr })

            -- Hunk Actions (Buffer)
            wk.register({
                h = {
                    name = "Hunk",
                    S = { gs.stage_buffer, "Hunk Stage Buffer" },
                    u = { gs.undo_stage_hunk, "Hunk Reset" },
                    R = { gs.reset_buffer, "Hunk Reset Buffer" },
                    p = { gs.preview_hunk, "Hunk Preview" },
                    b = { function() gs.blame_line({ full = true }) end, "Hunk Blame" },
                    d = { gs.diffthis, "Hunk Diff" },
                    D = { function() gs.diffthis("~") end, "Hunk Diff Buffer" },
                    t = { name = "Toggle", d = { gs.toggle_deleted, "Hunk Toggle Deleted" } },
                },
            }, { prefix = "<leader>", mode = "n", buffer = bufnr })
        end

        require("gitsigns").setup({
            on_attach = on_attach,
            -- FIXME: Gitsigns should lazyload Trouble
            -- Enabling this causes trouble to be loaded on startup
            trouble = false,
        })

        ----------------------------------------
        -- Scrollbar integration
        ----------------------------------------
        require("scrollbar.handlers.gitsigns").setup()
    end,
}
