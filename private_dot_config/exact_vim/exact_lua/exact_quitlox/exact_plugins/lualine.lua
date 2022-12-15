----------------------------------------
-- Statusline: Custom VSCode Colorscheme
----------------------------------------

import("lualine.themes.vscode", function(vscode)
	vscode.normal.a.fg = "white"
	vscode.normal.b.fg = "white"
	vscode.normal.c.fg = "white"
end)

----------------------------------------
-- Statusline: Custom Modules
----------------------------------------

-- Override 'encoding': Don't display if encoding is UTF-8.
local encoding = function()
	local ret, _ = (vim.bo.fenc or vim.go.enc):gsub("^utf%-8$", "")
	return ret
end
-- fileformat: Don't display if &ff is unix.
local fileformat = function()
	local ret, _ = vim.bo.fileformat:gsub("^unix$", "")
	return ret
end
local filename = {
	"filename",
	path = 0,
	symbols = {
		modified = "",
		readonly = "",
		unnamed = "",
		newfile = "",
	},
}

----------------------------------------
-- Statusline: Setup
----------------------------------------

import("lualine", function(lualine)
	lualine.setup({
		options = {
			theme = vscode,
			icons_enabled = true,

			component_separators = "|",
			section_separators = { left = "", right = "" },

			disabled_filetypes = {
				statusline = { "NvimTree" },
				winbar = {
					"NvimTree",
					"dap-repl",
					"dapui_scopes",
					"dapui_breakpoints",
					"dapui_stacks",
					"dapui_watches",
					"dapui_console",
				},
			},
			ignore_focus = {},
			always_divide_middle = true,
			globalstatus = true,
			refresh = {
				statusline = 1000,
				tabline = 1000,
				winbar = 1000,
			},
		},
		sections = {
			lualine_a = {
				{
					"mode",
					separator = { left = "" },
					padding = { right = 1 },
					fmt = function(str)
						return str:sub(1, 1)
					end,
				},
			},
			lualine_b = {
				"diff",
				"diagnostics",
				"gutentags#statusline",
			},
			lualine_c = { filename, "nvim-treesitter#statusline" },
			lualine_x = { encoding, fileformat, "filetype" },
			lualine_y = { { "branch", icon = { "", color = { fg = "white" } } } },
			lualine_z = { "location" },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { filename },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},

		winbar = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = {},
		},
		inactive_winbar = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { filename },
			lualine_x = {},
			lualine_y = {},
			lualine_z = {},
		},

		extensions = {},
	})
end)
