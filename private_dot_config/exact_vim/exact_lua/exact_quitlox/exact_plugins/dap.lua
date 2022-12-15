local path = require("quitlox.util.path")

local ok_dapui, dapui = pcall(require, "dapui")
local ok_tree_view, tree_view = pcall(require, "nvim-tree.view")
local ok_tree_api, tree_api = pcall(require, "nvim-tree.api")
if not (ok_dapui and ok_tree_api and ok_tree_view) then
	return
end

----------------------------------------
-- DAP
----------------------------------------

-- State
local nvim_tree_enabled = false

-- Logic
local function on_open()
	-- Remember whether the explorer was open
	nvim_tree_enabled = tree_view.is_visible()
	-- Close the explorer
	tree_api.tree.close()
	-- Deattach gitsigns
	require("gitsigns").toggle_signs(false)
	-- Open the DAP UI
	dapui.open({})
end

local function on_close()
	if nvim_tree_enabled then
		tree_api.tree.open()
	end
	dapui.close({})
	require("gitsigns").toggle_signs(true)
end

-- Configure DAP
import("dap", function(dap)
	-- Set log level
	dap.set_log_level("TRACE")

	dapui.setup({
		expand_lines = vim.fn.has("nvim-0.7") == 1,
	})

	-- Autmatically open/close DAP UI and Nvim-Tree
	dap.listeners.after.event_initialized["dapui_config"] = on_open
	dap.listeners.before.event_terminated["dapui_config"] = on_close
	dap.listeners.before.event_exited["dapui_config"] = on_close

	-- Logic: Evaluate single expression
	local evaluate = function()
		vim.ui.input({ prompt = "Expression to evaluate: " }, function(input)
			dapui.eval(input)
		end)
	end

	-- Load telescope extension
	import("telescope", function(telescope)
		telescope.load_extension("dap")
	end)
	-- Set keymaps for DAP UI
	import("which-key", function(wk)
		vim.keymap.set("n", "<F8>", "<cmd>DapStepOver<cr>", { noremap = true })
		vim.keymap.set("n", "<S-F8>", "<cmd>DapStepOut<cr>", { noremap = true })
		vim.keymap.set("n", "<F7>", "<cmd>DapStepIn<cr>", { noremap = true })

		wk.register({
			["<localleader>"] = {
				d = {
					name = "Debug",
					o = { dapui.open, "Debug UI Open" },
					c = { dapui.close, "Debug UI Close" },
					-- t = { dapui.toggle, "Debug UI Toggle" },
					e = { evaluate, "Evaluate Expression" },
					d = { dap.continue, "Debugger Launch/Continue" },
					r = { "<cmd>DapToggleRepl<cr>", "Open REPL" },
					s = {
						name = "Step",
						o = { "<cmd>DapStepOver<cr>", "Step Over (F8)" },
						u = { "<cmd>DapStepOut<cr>", "Step Out (Shift+F8)" },
						i = { "<cmd>DapStepIn<cr>", "Step Into (F7)" },
					},
					t = { "<cmd>DapToggleBreakpoint<cr>", "Breakpoint Toggle" },
					b = {
						name = "Breakpoint",
						c = {
							'<cmd>lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
							"Breakpoint Condition",
						},
						m = {
							'<cmd>lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>',
							"Breakpoint Message",
						},
					},
					l = {
						name = "List",
						c = { "<cmd>Telescope dap commands<cr>", "List Debug Commands" },
						d = { "<cmd>Telescope dap configurations<cr>", "List Debug Configurations" },
						b = { "<cmd>Telescope dap list_breakpoints<cr>", "List Debug Breakpoints" },
						v = { "<cmd>Telescope dap variables<cr>", "List Debug Variables" },
						f = { "<cmd>Telescope dap frames<cr>", "List Debug Frames" },
					},
				},
			},
		})
	end)
end)

-- Virtual Text while debugging
import("nvim-dap-virtual-text", function(virt)
	virt.setup()
end)

----------------------------------------
-- DAP: Launch.json
----------------------------------------

local function load_launch_json()
	import("dap.ext.vscode", function(vscode)
		local status, err = pcall(vscode.load_launchjs)
		if not status then
			import("notify", function(notify)
				notify(
					"Is there a typo in the config?\n\n" .. err,
					"ERROR",
					{ title = "Error while loading .vscode/launch.json" }
				)
			end)
		end
	end)
end

-- Register loading launch.json as keybinding
import("which-key", function(wk)
	wk.register({
		["<localleader>"] = {
			d = {
				name = "Debug",
				v = { load_launch_json, "Reload launch.json" },
			},
		},
	})
end)
-- Load launch.json on startup
load_launch_json()
-- Load launch.json when edited
local launch_group = vim.api.nvim_create_augroup("LaunchJson", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	group = launch_group,
	desc = "Reload launch.json on save",
	pattern = "launch.json",
	callback = load_launch_json,
})

----------------------------------------
-- DAP: Python
----------------------------------------

import({ "dap-python", "notify", "which-key" }, function(modules)
	local pythondap = modules["dap-python"]
	local notify = modules.notify
	local wk = modules["which-key"]

	local debugpy_path =
		path.concat({ vim.fn.stdpath("data"), "mason", "packages", "debugpy", "venv", "bin", "python" })
	if path.exists(debugpy_path) then
		-- Setup Python DAP and point to debugpy
		pythondap.setup(debugpy_path)
		-- Set pytest as default test runner
		pythondap.rest_runner = "pytest"

		-- Set keymaps specifically for python
		wk.register({
			["<localleader>"] = {
				d = {
					name = "Debug",
					x = { pythondap.test_class, "Debug Class" },
					y = { pythondap.test_method, "Debug Method" },
					--s = { pythondap.debug_selection, "Debug Selection" },
				},
			},
		})
	else
		notify(
			'For Python debugging, install debugpy using: ":MasonInstall debugpy"',
			"WARN",
			{ title = "No Python Debugging", timeout = 1000 }
		)
	end
end)

-- Signs
vim.fn.sign_define("DapBreakpoint", { text = "•", texthl = "ErrorMsg", linehl = "", numhl = "" })
-- Persistent Breakpoints
import("persistent-breakpoints", function(module)
	module.setup({
		load_breakpoints_event = { "BufReadPost" },
	})
end)
