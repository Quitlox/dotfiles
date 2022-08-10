local notify = require("notify")

local missing_plugins = {}
local missing_plugin_notification = {}

local function missing_plugin_reset()
	missing_plugins = {}
end

--- Spawn a notification warning the user that a plugin is not installed
-- @param name The name of the plugin that is missing
local missing_plugin_notify = function(plugin_name)
	local notification = { title = "Missing Plugin", timeout = 500, on_close = missing_plugin_reset }
	table.insert(missing_plugins, plugin_name)

	-- There is already a notification open for another missing plugin
	if missing_plugin_notification ~= {} then
		notification["replace"] = missing_plugin_notification.id
	end

	-- Create the message
	local message = ""
	table.foreach(missing_plugins, function(_, name)
		message = message .. name .. "\n"
	end)
	-- Spawn or update the notification
	missing_plugin_notification = notify(message, "warn", notification)
end

local load_module = function(module_name)
	local status_ok, module = pcall(require, module_name)
	if not status_ok then
		missing_plugin_notify(module_name)
	end
	return status_ok, module
end

return {
	missing_plugin_notify = missing_plugin_notify,
	load_module = load_module,
}
