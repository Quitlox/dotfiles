local path = require("quitlox.util.path")

----------------------------------------
-- DAP
----------------------------------------

-- Configure DAP
import("dap", function(dap)
	-- Set log level
	dap.set_log_level("TRACE")

	import("dapui", function(dapui)
		dapui.setup({})

		-- Autmatically open UI
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

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
						t = { dapui.toggle, "Debug UI Toggle" },
						e = { evaluate, "Evaluate Expression" },
						d = { dap.continue, "Debugger Launch/Continue" },
						r = { "<cmd>DapToggleRepl<cr>", "Open REPL" },
						s = {
							name = "Step",
							o = { "<cmd>DapStepOver<cr>", "Step Over (F8)" },
							u = { "<cmd>DapStepOut<cr>", "Step Out (Shift+F8)" },
							i = { "<cmd>DapStepIn<cr>", "Step Into (F7)" },
						},
						b = { "<cmd>DapToggleBreakpoint<cr>", "Breakpoint Toggle" },
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

----------------------------------------
-- DAP: Python
----------------------------------------

local path = require("quitlox.util.path")

import("dap-python", function(pythondap)
	local debugpy_path =
		path.concat({ vim.fn.stdpath("data"), "mason", "packages", "debugpy", "venv", "bin", "python" })
	if path.exists(debugpy_path) then
		-- Setup Python DAP and point to debugpy
		pythondap.setup(debugpy_path)
		-- Set pytest as default test runner
		pythondap.rest_runner = "pytest"

		-- Set keymaps specifically for python
		import("which-key", function(wk)
			wk.register({
				["<localleader>"] = {
					d = {
						name = "Debug",
						c = { pythondap.test_class, "Debug Class" },
						m = { pythondap.test_method, "Debug Method" },
						--s = { pythondap.debug_selection, "Debug Selection" },
					},
				},
			})
		end)
	else
		import("notify", function(notify)
			notify(
				'For Python debugging, install debugpy using: ":MasonInstall debugpy"',
				"WARN",
				{ title = "No Python Debugging", timeout = 1000 }
			)
		end)
	end
end)
