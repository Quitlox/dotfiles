----------------------------------------
-- Settings
----------------------------------------

local config = function(x, width)
	require("FTerm").setup({
		winblend = 0,
		dimensions = { x = x, width = width },
	})
end

----------------------------------------
-- Logic
----------------------------------------

-- TODO: Actually calculate offset

local explorer_view = require("nvim-tree.view")
local explorer_api = require("nvim-tree.api")
local Event = require("nvim-tree.api").events.Event

-- Center the terminal in the editor area
local open_state_config = function()
	-- Account for the nvim-tree if it is open
	config(0.7, 0.7)
end
local closed_state_config = function()
	config(0.5, 0.8)
end

-- Set the config according to the nvim-tree state
local explorer_open = explorer_view.is_visible()
if explorer_open then
	open_state_config()
else
	closed_state_config()
end

-- Update the config if the nvim-tree state changes
explorer_api.events.subscribe(Event.TreeOpen, open_state_config)
explorer_api.events.subscribe(Event.TreeClose, closed_state_config)

----------------------------------------
-- Keybindings
----------------------------------------

local status_ok, wk = require("quitlox.util").load_module("which-key")
if not status_ok then
	return
end

wk.register({
	t = { "<cmd>lua require('FTerm').toggle()<cr>", "Toggle Terminal" },
}, { prefix = "<leader>T" })
