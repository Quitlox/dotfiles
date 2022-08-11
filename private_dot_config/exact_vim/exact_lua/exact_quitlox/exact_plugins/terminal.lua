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

-- Center the terminal in the editor area
-- TODO: Actually calculate offset
local open_state_config = function()
	-- Account for the nvim-tree if it is open
	config(0.7, 0.7)
end
local closed_state_config = function()
	config(0.5, 0.8)
end

-- Set the config according to the nvim-tree state
import("nvim-tree.view", function(explorer_view)
	local explorer_open = explorer_view.is_visible()
	if explorer_open then
		open_state_config()
	else
		closed_state_config()
	end
end)

-- Update the config if the nvim-tree state changes
import("nvim-tree.api", function(explorer_api)
	local Event = explorer_api.events.Event
	explorer_api.events.subscribe(Event.TreeOpen, open_state_config)
	explorer_api.events.subscribe(Event.TreeClose, closed_state_config)
end)

----------------------------------------
-- Keybindings
----------------------------------------

import("which-key", function(wk)
	wk.register({
		t = { "<cmd>lua require('FTerm').toggle()<cr>", "Toggle Terminal" },
	}, { prefix = "<leader>T" })
end)
