local status_ok, c = require("quitlox.util").load_module("vscode.colors")
if not status_ok then
	return
end

----------------------------------------
-- Bufferline: Options
----------------------------------------

vim.opt.termguicolors = true

----------------------------------------
-- Bufferline: Setup
----------------------------------------

import("bufferline", function(bufferline)
	bufferline.setup({
		options = {
			mode = "buffers",
			themable = true,
			diagnostics = "nvim_lsp",
			--- count is an integer representing total count of errors
			--- level is a string "error" | "warning"
			--- diagnostics_dict is a dictionary from error level ("error", "warning"
			--- or "info")to number of errors for each level.
			--- this should return a string
			--- Don't get too fancy as this function will be executed a lot
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				local icon = level:match("error") and " " or " "
				return " " .. icon .. count
			end,

			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					highlight = "Directory",
					text_align = "left",
				},
			},

			show_buffer_default_icon = true,
			separator_style = "slant",

			buffer_close_icon = "",
			close_icon = "",
			indicator_icon = " ",
			left_trunc_marker = "",
			modified_icon = "●",
			right_trunc_marker = "",
			show_close_icon = false,
			show_tab_indicators = true,

			custom_areas = {
				right = function()
					local result = {}
					local seve = vim.diagnostic.severity
					local error = vim.diagnostic.get(0, { severity = seve.ERROR })
					local warning = vim.diagnostic.get(0, { severity = seve.WARN })
					local info = vim.diagnostic.get(0, { severity = seve.INFO })
					local hint = vim.diagnostic.get(0, { severity = seve.HINT })

					if error ~= 0 then
						table.insert(result, { text = "  " .. error, guifg = c.vscRed })
					end

					if warning ~= 0 then
						table.insert(result, { text = "  " .. warning, guifg = c.vscYellowOrange })
					end

					if hint ~= 0 then
						table.insert(result, { text = "  " .. hint, guifg = c.vscGreen })
					end

					if info ~= 0 then
						table.insert(result, { text = "  " .. info, guifg = c.vscLightBlue })
					end
					return result
				end,
			},
		},
		-- Until https://github.com/akinsho/bufferline.nvim/issues/382 is resolved
		highlights = {
			separator = {
				fg = "#252526",
			},
			separator_selected = {
				fg = "#252526",
			},
			separator_visible = {
				fg = "#252526",
			},
		},
	})
end)

----------------------------------------
-- Bufferline: Keybindings - Buffer
----------------------------------------

import("which-key", function(wk)
	wk.register({
		["<leader>"] = {
			b = {
				name = "Buffer",
				n = { "<cmd>BufferLineCycleNext<cr>", "Buffer Next" },
				p = { "<cmd>BufferLineCyclePrev<cr>", "Buffer Prev" },
				b = { "<cmd>BufferLinePick<cr>", "Buffer pick" },
				d = { ":Bdelete<cr>", "Buffer Delete" },
				o = { ":BufOnly<cr>", "Buffer Only" },
				m = {
					name = "Move",
					n = { "<cmd>BufferLineMoveNext<cr>", "Buffer Move Next" },
					p = { "<cmd>BufferLineMovePrev<cr>", "Buffer Move Prev" },
				},
			},
		},
	}, { silent = true })
end)

-- vim.cmd([[hi BufferLineSeparator guifg=c.c.vscFoldBackground]])
-- vim.cmd([[hi BufferLineSeparatorSelected guifg=c.vscFoldBackground]])
-- vim.cmd([[hi BufferLineSeparatorVisible guifg=c.vscFoldBackground]])
