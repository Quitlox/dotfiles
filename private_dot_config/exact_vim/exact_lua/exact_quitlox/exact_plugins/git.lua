----------------------------------------------------------------------
--                             Gitsigns                             --
----------------------------------------------------------------------
-- Shows git signs for line additions, changes and deletions in the gutter (next
-- to the line number column)

import({ "gitsigns", "which-key" }, function(modules)
    local gs = modules.gitsigns
    local wk = modules["which-key"]

    gs.setup({
        on_attach = function(bufnr)
            -- Git Hunk Navigation
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

            -- Git Blame
            wk.register({
                b = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Toggle git Blame" },
            }, { prefix = "<leader>T", buffer = bufnr })

            -- Git List
            wk.register({
                g = {
                    name = "Git",
                    l = { "<cmd>Gitsigns setqflist<cr>", "Git List Changes" },
                },
            }, { prefix = "<leader>", buffer = bufnr })

            -- Hunk Actions
            wk.register({
                h = {
                    name = "Hunk",
                    s = { "<cmd>Gitsigns stage_hunk<cr>", "Hunk Stage" },
                    r = { "<cmd>Gitsigns reset_hunk<cr>", "Hunk Reset" },
                },
            }, { prefix = "<leader>", mode = "nv", buffer = bufnr })
            -- Hunk Actions
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

            -- Text object
            -- wk.register({
            --     ["ih"] = {":<C-U>Gitsigns select_hunk<CR>","Text Object: Hunk"},
            -- },{mode="ox", })
        end,
    })
end)

----------------------------------------------------------------------
--                             DiffView                             --
----------------------------------------------------------------------
-- Improves the standard vimdiff mode, adding better highlighting and shortcuts.

import({ "diffview", "diffview.actions", "which-key" }, function(modules)
    local diffview = modules["diffview"]
    local actions = modules["diffview.actions"]
    local wk = modules["which-key"]

    diffview.setup({})

    wk.register({
        g = {
            name = "Git",
            d = {
                name = "Diff",
                h = { "<cmd>DiffviewFileHistory<cr>", "Git Diff History" },
                f = { "<cmd>DiffviewFileHistory %<cr>", "Git Diff File history" },
                o = { "<cmd>DiffviewOpen<cr>", "Git Diff Open (compare against current index)" },
                c = { "<cmd>DiffviewClose<cr>", "Git Diff Close" },
                t = { "<cmd>DiffviewToggleFiles<cr>", "Git Diff Toggle files" },
                l = { "<cmd>DiffviewFocusFiles<cr>", "Git Diff Locate (focus) files" },
                r = { "<cmd>DiffviewRefresh<cr>", "Git Diff Refresh" },
            },
        },
    }, { prefix = "<leader>" })
end)

----------------------------------------------------------------------
--                              Neogit                              --
----------------------------------------------------------------------

import({ "neogit", "which-key" }, function(modules)
    local neogit = modules["neogit"]
    local wk = modules["which-key"]

    neogit.setup({
        kind = "split",
        integrations = {
            diffview = true,
        },
    })

    wk.register({
        g = {
            name = "Git",
            s = { neogit.open, "Git Status" },
            c = { function() neogit.open({ "commit" }) end, "Git Commit" },

            -- Misc Telescope stuff
            b = { "<cmd>Telescope git_branches<cr>", "Open Git Branches" },
        },
    }, { prefix = "<leader>" })
end)
