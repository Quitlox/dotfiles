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
                if vim.wo.diff then
                    return "]h"
                end
                vim.schedule(function() gs.next_hunk() end)
                return "<Ignore>"
            end

            local function prev_hunk()
                if vim.wo.diff then
                    return "[h"
                end
                vim.schedule(function() gs.prev_hunk() end)
                return "<Ignore>"
            end

            vim.keymap.set("n", "]h", next_hunk, { expr = true, buffer = bufnr })
            vim.keymap.set("n", "[h", prev_hunk, { expr = true, buffer = bufnr })

            wk.add({
                { "[h", desc = "Next Change" },
                { "]h", desc = "Prev Change" },
            })

            ----------------------------------------
            -- Misc
            ----------------------------------------

            -- Git Blame
            wk.add({
                { "<leader>Tb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle git Blame" },
            }, { buffer = bufnr })

            -- Git List
            wk.add({
                { "<leader>g", group = "Git" },
                { "<leader>gl", group = "List" },
                { "<leader>glc", "<cmd>Gitsigns setqflist<cr>", desc = "Git list Changes" },
            }, { buffer = bufnr })

            -- Hunk Actions (Line)
            local _mapping = {
                { "<leader>h", group = "Hunk" },
                { "<leader>hs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Hunk Stage" },
                { "<leader>hr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Hunk Reset" },
            }
            wk.add(_mapping, { mode = "n", buffer = bufnr })
            wk.add(_mapping, { mode = "v", buffer = bufnr })

            -- Hunk Actions (Buffer)
            wk.add({
                { "<leader>h", group = "Hunk" },
                { "<leader>hS", gs.stage_buffer, desc = "Hunk Stage Buffer" },
                { "<leader>hu", gs.undo_stage_hunk, desc = "Hunk Reset" },
                { "<leader>hR", gs.reset_buffer, desc = "Hunk Reset Buffer" },
                { "<leader>hp", gs.preview_hunk, desc = "Hunk Preview" },
                { "<leader>hb", function() gs.blame_line({ full = true }) end, desc = "Hunk Blame" },
                { "<leader>hd", gs.diffthis, desc = "Hunk Diff" },
                { "<leader>hD", function() gs.diffthis("~") end, desc = "Hunk Diff Buffer" },
                { "<leader>ht", group = "Toggle" },
                { "<leader>htd", gs.toggle_deleted, desc = "Hunk Toggle Deleted" },
            }, { mode = "n", buffer = bufnr })
        end

        require("gitsigns").setup({
            on_attach = on_attach,
            -- FIXME: Gitsigns should lazyload Trouble
            -- Enabling this causes trouble to be loaded on startup
            trouble = false,
            _signs_staged_enable = true,
        })

        ----------------------------------------
        -- Integrations
        ----------------------------------------
        require("scrollbar.handlers.gitsigns").setup()
    end,
}
