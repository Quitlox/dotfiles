-- This shouldn't be necessary?
-- It seems the highlighting groups are added multiple times?
-- Maybe due to the use of multiple imports all over the config
vim.cmd([[
highlight NotifyERRORBorder guifg=#8A1F1F
highlight NotifyWARNBorder guifg=#79491D
highlight NotifyINFOBorder guifg=#4F6752
highlight NotifyDEBUGBorder guifg=#8B8B8B
highlight NotifyTRACEBorder guifg=#4F3552
highlight NotifyERRORIcon guifg=#F70067
highlight NotifyWARNIcon guifg=#F79000
highlight NotifyINFOIcon guifg=#A9FF68
highlight NotifyDEBUGIcon guifg=#8B8B8B
highlight NotifyTRACEIcon guifg=#D484FF
highlight NotifyERRORTitle  guifg=#F70067
highlight NotifyWARNTitle guifg=#F79000
highlight NotifyINFOTitle guifg=#A9FF68
highlight NotifyDEBUGTitle  guifg=#8B8B8B
highlight NotifyTRACETitle  guifg=#D484FF
highlight link NotifyERRORBody Normal
highlight link NotifyWARNBody Normal
highlight link NotifyINFOBody Normal
highlight link NotifyDEBUGBody Normal
highlight link NotifyTRACEBody Normal
]])

import("notify", function(notify)
	notify.setup({
		max_width = function()
			return math.floor(math.max(vim.o.columns / 2, 30))
		end,
	})

	import("telescope", function(telescope)
		telescope.load_extension("notify")
		import("which-key", function(wk)
			wk.register({
				["<leader>"] = {
					v = {
						name = "Vim",
						l = {
							name = "list",
							n = { "<cmd>Telescope notify<cr>", "Vim List Notifications" },
						},
					},
					["<space>"] = "which_key_ignore", -- EasyMotion
					["<enter>"] = "which_key_ignore", -- NoHighlight
				},
			})
		end)
	end)
end)
