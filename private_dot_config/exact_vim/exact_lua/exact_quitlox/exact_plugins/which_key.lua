local status_ok, wk = require("quitlox.util").load_module("which-key")
if not status_ok then
	return
end

wk.setup({
	plugins = {
		presets = {
			operators = false,
			motions = false,
			text_objects = false,
			windows = false,
			nav = false,
			z = true,
			g = false,
		},
	},
	key_labels = {
		["<space>"] = "SPC",
		["<CR>"] = "RET",
		["<cr>"] = "RET",
		["<tab>"] = "TAB",
	},
	icons = { group = "", separator = "ﰲ" },
	layout = {
		align = "center",
	},
	window = {
		border = "single",
		winblend = 0,
	},
})

----------------------------------------
-- KEYBINDINGS
----------------------------------------

wk.register({
	["<leader>"] = {
		s = { ":wa<cr>", "save" },
	},
})

----------------------------------------
-- KEYBINDINGS: WINDOW
----------------------------------------
wk.register({
	["<leader>"] = {
		s = { ":wa<cr>", "save" },
		w = {
			name = "Window",
			j = { "<C-W>j", "which_key_ignore" },
			k = { "<C-W>k", "which_key_ignore" },
			h = { "<C-W>h", "which_key_ignore" },
			l = { "<C-W>l", "which_key_ignore" },
			o = { "<C-W>o", "Window Only" },
			v = { "<C-W>s", "Window vSplit" },
			b = { "<C-W>v", "Window Split" },
			d = { "<C-W>q", "Window Delete" },
			w = { ":new<CR>", "New Window" },
			r = {
				name = "Resize",
				k = { ":resize +2<CR>", "Window Resize Up" },
				j = { ":resize -2<CR>", "Window Resize Down" },
				h = { ":vertical resize -2<CR>", "Window Resize Left" },
				l = { ":vertical resize +2<CR>", "Window Resize Right" },
			},
		},
	},
	["<C-Down>"] = { ":resize +2<CR>", "which_key_ignore" },
	["<C-Up>"] = { ":resize -2<CR>", "which_key_ignore" },
	["<C-Right>"] = { ":vertical resize +2<CR>", "which_key_ignore" },
	["<C-Left>"] = { ":vertical resize -2<CR>", "which_key_ignore" },
})

----------------------------------------
-- KEYBINDINGS: TAB
----------------------------------------
wk.register({
	["<leader>"] = {
		t = {
			name = "Tab",
			t = { ":tabnew<cr>", "[T]ab :new" },
			o = { ":tabonly<cr>", "[T]ab [o]nly" },
			d = { ":tabclose<cr>", "[T]ab [d]elete" },
			n = { ":tabnext<cr>", "[T]ab [n]next" },
			p = { ":tabprevious<cr>", "[T]ab [p]revious" },
			m = {
				name = "move",
				h = { ":-tabmove<cr>", "[T]ab [m]ove left" },
				l = { ":+tabmove<cr>", "[T]ab [m]ove right" },
			},
		},
	},
})

----------------------------------------
-- KEYBINDINGS: PLUGINS MISCELLANEOUS
----------------------------------------

wk.register({
	["<leader>"] = {
		["<leader>"] = {
			i = { "<cmd>IconPickerNormal alt_font symbols nerd_font emoji<cr>", "Icon Picker" },
		},
	},
},{ noremap = true, silent = true })

----------------------------------------
-- KEYBINDINGS: MISCELLANEOUS
----------------------------------------
wk.register({
	["<leader>"] = {
		v = {
			name = "Vim",
			s = { ":source ~/.config/vim/vimrc<cr>", "[v]im [s]ource vimrc" },
			l = {
				name = "list",
				f = { "<cmd>Telescope filetypes theme=dropdown<cr>", "Vim List Filetypes" },
				r = { "<cmd>Telescope registers theme=dropdown<cr>", "Vim List Registers" },
				o = { "<cmd>Telescope vim_options theme=dropdown<cr>", "Vim List Options" },
				a = { "<cmd>Telescope autocommands theme=dropdown<cr>", "Vim List Autocommands" },
			},
		},
		["<space>"] = "which_key_ignore", -- EasyMotion
		["<enter>"] = "which_key_ignore", -- NoHighlight
	},
})

----------------------------------------
-- PLUGIN: VIMTEX (LATEX)
----------------------------------------
wk.register({
	["<localleader>"] = {
		l = {
			name = "[L]aTeX",
			a = "context menu",
			C = "[c]lean full",
			c = "[c]lean",
			e = "[e]rrors",
			g = "status",
			G = "status all",
			I = "[i]nfo full",
			i = "[i]nfo",
			K = "stop all",
			k = "stop",
			l = "compile",
			L = "compile selected",
			m = "i[m]aps list",
			o = "compile [o]utput",
			q = "log",
			s = "toggle main",
			t = "[t]oc open",
			T = "[t]oc toggle",
			v = "[v]iew",
			X = "reload state",
			x = "reload",
		},
	},
})

wk.register({
	["<leader>"] = { d = { "<cmd>DogeGenerate<cr>", "Generate Documentation" } },
})
