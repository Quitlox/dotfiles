local function on_attach(bufnr)
	-- Only do something if gitsigns is available
	import({ "gitsigns", "which-key" }, function(modules)
		local gs = modules.gitsigns
		local wk = modules["which-key"]

		local function map(mode, lhs, rhs, opts)
			opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
			vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
		end

		-- Git Hunk Navigation
		map("n", "]g", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
		map("n", "[g", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

		-- Git Blame
		wk.register({
			b = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Toggle git Blame" },
		}, { prefix = "<leader>T" })

		-- Git List
		wk.register({
			g = {
				name = "Git",
				l = { "<cmd>Gitsigns setqflist<cr>", "Git List Changes" },
			},
		}, { prefix = "<leader>" })

		-- Hunk Actions
        local _mapping = {
				name = "Hunk",
				s = { "<cmd>Gitsigns stage_hunk<cr>", "Hunk Stage" },
				r = { "<cmd>Gitsigns reset_hunk<cr>", "Hunk Reset" },
			}
		wk.register(_mapping, { prefix = "<leader>", mode = "n" })
		wk.register(_mapping, { prefix = "<leader>", mode = "v" })

		-- Hunk Actions
		wk.register({
			h = {
				name = "Hunk",
				S = { gs.stage_buffer, "Hunk Stage Buffer" },
				u = { gs.undo_stage_hunk, "Hunk Reset" },
				R = { gs.reset_buffer, "Hunk Reset Buffer" },
				p = { gs.preview_hunk, "Hunk Preview" },
				b = {
					function()
						gs.blame_line({ full = true })
					end,
					"Hunk Blame",
				},
				d = { gs.diffthis, "Hunk Diff" },
				D = {
					function()
						gs.diffthis("~")
					end,
					"Hunk Diff Buffer",
				},
				t = {
					name = "Toggle",
					d = { gs.toggle_deleted, "Hunk Toggle Deleted" },
				},
			},
		}, { prefix = "<leader>", mode = "n" })

		-- -- Text object
		-- map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
	end)
end

import({ "gitsigns" }, function(gs)
	gs.setup({
		on_attach = on_attach,
	})
end)

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
                h = {"<cmd>DiffviewFileHistory<cr>", "Git Diff History"},
                f = {"<cmd>DiffviewFileHistory %<cr>", "Git Diff File history"},
                o = {"<cmd>DiffviewOpen<cr>", "Git Diff Open (compare against current index)"},
                c = {"<cmd>DiffviewClose<cr>", "Git Diff Close"},
                t = {"<cmd>DiffviewToggleFiles<cr>", "Git Diff Toggle files"},
                l = {"<cmd>DiffviewFocusFiles<cr>", "Git Diff Locate (focus) files"},
                r = {"<cmd>DiffviewRefresh<cr>", "Git Diff Refresh"},
			},
		},
	}, { prefix = "<leader>" })
end)
