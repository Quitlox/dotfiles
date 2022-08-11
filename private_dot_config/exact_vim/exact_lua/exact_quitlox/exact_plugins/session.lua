-- Workaround
-- https://github.com/rmagatti/auto-session/issues/64
if not vim.fn.has("nvim-0.8") == 1 then
	function _G.close_all_floating_wins()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local config = vim.api.nvim_win_get_config(win)
			if config.relative ~= "" then
				vim.api.nvim_win_close(win, false)
			end
		end
	end
else
	function _G.close_all_floating_wins() end
end

----------------------------------------
-- Session Manager: auto-session
----------------------------------------

import("auto-session", function(autosession)
	autosession.setup({
		log_level = "warn",
		auto_session_suppress_dirs = { "~/", "~/Downloads", "~/Documents", "/tmp" },
		pre_save_cmds = { _G.close_all_floating_wins },
	})
end)
